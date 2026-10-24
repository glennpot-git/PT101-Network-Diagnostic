import java.util.ArrayList;
import java.util.List;

public class CpuSimulator {

    static class Process {
        String id;
        int arrival;
        int burst;

        Process(String id, int arrival, int burst) {
            this.id = id;
            this.arrival = arrival;
            this.burst = burst;
        }
    }

    public static void main(String[] args) {
        List<Process> workload = new ArrayList<>();
        workload.add(new Process("P1", 0, 8));
        workload.add(new Process("P2", 1, 4));
        workload.add(new Process("P3", 2, 9));
        workload.add(new Process("P4", 3, 5));

        System.out.println("=== CPU SCHEDULING ALGORITHM SIMULATION REPORT ===");
        System.out.println("Input Workload:");
        System.out.printf("%-8s | %-12s | %-10s%n", "Process", "Arrival Time", "Burst Time");
        for (Process p : workload) {
            System.out.printf("%-8s | %-12d | %-10d%n", p.id, p.arrival, p.burst);
        }
        System.out.println("\n---------------------------------------------------------");

        List<String> fcfsGantt = new ArrayList<>();
        int currentTime = 0;
        double totalWtFcfs = 0;
        double totalTatFcfs = 0;

        for (Process p : workload) {
            if (currentTime < p.arrival) {
                currentTime = p.arrival;
            }
            int startTime = currentTime;
            int completionTime = startTime + p.burst;
            int tat = completionTime - p.arrival;
            int wt = tat - p.burst;

            totalWtFcfs += wt;
            totalTatFcfs += tat;
            fcfsGantt.add(String.format("%s (%d-%d)", p.id, startTime, completionTime));
            currentTime = completionTime;
        }

        double avgWtFcfs = totalWtFcfs / workload.size();
        double avgTatFcfs = totalTatFcfs / workload.size();

        System.out.println("\n[1] First-Come, First-Served (FCFS)");
        System.out.println("Gantt Chart: | " + String.join(" | ", fcfsGantt) + " |");
        System.out.printf("Average Waiting Time: %.2f ms%n", avgWtFcfs);
        System.out.printf("Average Turnaround Time: %.2f ms%n", avgTatFcfs);

        List<String> sjfGantt = new ArrayList<>();
        int n = workload.size();
        int completed = 0;
        currentTime = 0;
        double totalWtSjf = 0;
        double totalTatSjf = 0;
        boolean[] visited = new boolean[n];

        while (completed < n) {
            int idx = -1;
            int minBurst = Integer.MAX_VALUE;

            for (int i = 0; i < n; i++) {
                Process p = workload.get(i);
                if (p.arrival <= currentTime && !visited[i]) {
                    if (p.burst < minBurst) {
                        minBurst = p.burst;
                        idx = i;
                    } else if (p.burst == minBurst) {
                        if (p.arrival < workload.get(idx).arrival) {
                            idx = i;
                        }
                    }
                }
            }

            if (idx != -1) {
                Process p = workload.get(idx);
                int startTime = currentTime;
                int completionTime = startTime + p.burst;
                int tat = completionTime - p.arrival;
                int wt = tat - p.burst;

                totalWtSjf += wt;
                totalTatSjf += tat;
                sjfGantt.add(String.format("%s (%d-%d)", p.id, startTime, completionTime));

                currentTime = completionTime;
                visited[idx] = true;
                completed++;
            } else {
                currentTime++;
            }
        }

        double avgWtSjf = totalWtSjf / n;
        double avgTatSjf = totalTatSjf / n;

        System.out.println("\n[2] Shortest Job First (SJF - Non-preemptive)");
        System.out.println("Gantt Chart: | " + String.join(" | ", sjfGantt) + " |");
        System.out.printf("Average Waiting Time: %.2f ms%n", avgWtSjf);
        System.out.printf("Average Turnaround Time: %.2f ms%n", avgTatSjf);

        double diffWt = avgWtFcfs - avgWtSjf;
        System.out.printf("%nConclusion: SJF reduced average waiting time by %.1f ms compared to FCFS.%n", diffWt);
    }
}