package model;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class Poll {
    private int id;
    private String question;
    private String description;
    private Date deadline;
    private boolean active;
    private int totalVotes;
    private List<PollOption> options;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getTotalVotes() { return totalVotes; }
    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }

    public List<PollOption> getOptions() { return options; }
    public void setOptions(List<PollOption> options) { this.options = options; }

    // Polling dianggap terbuka jika aktif dan deadline belum lewat
    public boolean isOpen() {
        return active && deadline != null
                && !deadline.toLocalDate().isBefore(LocalDate.now());
    }
}