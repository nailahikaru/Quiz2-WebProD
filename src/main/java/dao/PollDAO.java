package dao;

import model.*;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class PollDAO {

    // READ: semua polling + total suara
    public List<Poll> findAll() throws SQLException {
        String sql = "SELECT p.*, (SELECT COUNT(*) FROM poll_votes v WHERE v.poll_id=p.id) AS total " +
                     "FROM polls p ORDER BY p.created_at DESC";
        List<Poll> list = new ArrayList<>();
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // READ: satu polling + opsi + jumlah suara tiap opsi
    public Poll findById(int id) throws SQLException {
        try (Connection c = DBConnection.get()) {
            Poll p = null;
            try (PreparedStatement ps = c.prepareStatement("SELECT p.*, 0 AS total FROM polls p WHERE p.id=?")) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) p = map(rs); else return null;
            }
            String sql = "SELECT o.id, o.label, COUNT(v.id) AS total FROM poll_options o " +
                         "LEFT JOIN poll_votes v ON v.option_id=o.id WHERE o.poll_id=? GROUP BY o.id, o.label";
            List<PollOption> opts = new ArrayList<>();
            int sum = 0;
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    PollOption o = new PollOption();
                    o.setId(rs.getInt("id"));
                    o.setLabel(rs.getString("label"));
                    o.setTotal(rs.getInt("total"));
                    sum += o.getTotal();
                    opts.add(o);
                }
            }
            p.setOptions(opts);
            p.setTotalVotes(sum);
            return p;
        }
    }

    // CREATE: polling + opsinya dalam satu transaksi
    public void create(long userId, String question, String desc, String deadline, String[] options)
            throws SQLException {
        try (Connection c = DBConnection.get()) {
            c.setAutoCommit(false);
            try {
                int pollId;
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO polls(user_id, question, description, deadline) VALUES (?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setLong(1, userId);
                    ps.setString(2, question);
                    ps.setString(3, desc);
                    ps.setDate(4, java.sql.Date.valueOf(deadline));
                    ps.executeUpdate();
                    ResultSet k = ps.getGeneratedKeys();
                    k.next();
                    pollId = k.getInt(1);
                }
                try (PreparedStatement ps = c.prepareStatement(
                        "INSERT INTO poll_options(poll_id, label) VALUES (?,?)")) {
                    for (String o : options) {
                        if (o == null || o.isBlank()) continue;
                        ps.setInt(1, pollId);
                        ps.setString(2, o.trim());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
                c.commit();
            } catch (SQLException e) { c.rollback(); throw e; }
        }
    }

    // UPDATE: pertanyaan, deskripsi, deadline, status
    public void update(int id, String question, String desc, String deadline, boolean active)
            throws SQLException {
        String sql = "UPDATE polls SET question=?, description=?, deadline=?, is_active=? WHERE id=?";
        try (Connection c = DBConnection.get(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, question);
            ps.setString(2, desc);
            ps.setDate(3, java.sql.Date.valueOf(deadline));
            ps.setBoolean(4, active);
            ps.setInt(5, id);
            ps.executeUpdate();
        }
    }

    // DELETE: opsi dan suara ikut terhapus (ON DELETE CASCADE)
    public void delete(int id) throws SQLException {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement("DELETE FROM polls WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // VOTE
    public boolean hasVoted(int pollId, long userId) throws SQLException {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement(
                 "SELECT 1 FROM poll_votes WHERE poll_id=? AND user_id=?")) {
            ps.setInt(1, pollId);
            ps.setLong(2, userId);
            return ps.executeQuery().next();
        }
    }

    public void vote(int pollId, int optionId, long userId) throws SQLException {
        try (Connection c = DBConnection.get();
             PreparedStatement ps = c.prepareStatement(
                 "INSERT INTO poll_votes(poll_id, option_id, user_id) VALUES (?,?,?)")) {
            ps.setInt(1, pollId);
            ps.setInt(2, optionId);
            ps.setLong(3, userId);
            ps.executeUpdate();
        }
    }

    private Poll map(ResultSet rs) throws SQLException {
        Poll p = new Poll();
        p.setId(rs.getInt("id"));
        p.setQuestion(rs.getString("question"));
        p.setDescription(rs.getString("description"));
        p.setDeadline(rs.getDate("deadline"));
        p.setActive(rs.getBoolean("is_active"));
        p.setTotalVotes(rs.getInt("total"));
        return p;
    }
}