import { ChangeDetectionStrategy, Component, computed, signal, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms'

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AppComponent implements OnInit, OnDestroy {
  @ViewChild('logContainer') logContainer!: ElementRef;

  constructor() { }
  title = 'web_app';

  // State Signals (similar to Flutter's ValueNotifier/setState)
  currentTab = signal<AppTab>('tickets');
  currentStatusFilter = signal<Ticket['status'] | null>(null);

  tickets = signal<Ticket[]>([
    { id: 1001, subject: 'Payment gateway down after midnight deployment.', status: 'Open', createdAt: '2025-10-25 09:30' },
    { id: 1002, subject: 'User data sync failing for APAC region.', status: 'In Progress', createdAt: '2025-10-24 14:15' },
    { id: 1003, subject: 'Feature Request: Add dark mode to dashboard.', status: 'Closed', createdAt: '2025-10-20 11:00' },
    { id: 1004, subject: 'Internal server error 500 on report generation.', status: 'Open', createdAt: '2025-10-25 10:10' },
    { id: 1005, subject: 'Typo in welcome email template.', status: 'In Progress', createdAt: '2025-10-23 09:00' },
  ]);

  logs = signal<string[]>([
    'INFO: Application initialized successfully.',
    'INFO: Establishing database connection...',
    'WARN: High latency detected on API endpoint /users/102',
    'ERROR: Failed to retrieve user session data.',
  ]);

  knowledgeText = signal<string>(
    '# Welcome to the Internal Knowledge Base\n\nThis system allows documentation of common support issues and solutions. Use basic markdown syntax for formatting.\n\n- Issue 1: Login failure (check user permissions)\n- Issue 2: Reporting delays (check queue status)\n\n**Tip:** Keep articles concise and searchable.'
  );

  // Computed Signals (Derived State)
  filteredTickets = computed(() => {
    const filter = this.currentStatusFilter();
    if (!filter) {
      return this.tickets();
    }
    return this.tickets().filter(t => t.status === filter);
  });

  // computed counts for filters
  openTickets = computed(() => this.tickets().filter(t => t.status === 'Open'));
  inProgressTickets = computed(() => this.tickets().filter(t => t.status === 'In Progress'));
  closedTickets = computed(() => this.tickets().filter(t => t.status === 'Closed'));

  // Log simulation info
  private logInterval: any;



  ngOnInit() { }

  ngOnDestroy() {
    this.stopLogSimulation();
  }

  switchTab(tab: AppTab) {
    this.currentTab.set(tab);

    if (tab === 'logs') {
      this.startLogSimulation();
    } else {
      this.stopLogSimulation();
    }
  }

  stopLogSimulation() {
    if (this.logInterval) {
      clearInterval(this.logInterval);
      this.logInterval = null;
    }
  }

  startLogSimulation() {
    if (this.logInterval) {
      return; // Already running
    }

    const logTypes = ['INFO', 'WARN', 'DEBUG', 'ERROR'];
    const logMessages = [
      'Processing background job #',
      'User activity registered from IP: ',
      'Cache refresh initiated for module: ',
      'Access token expired for service: ',
      'CRITICAL memory usage alert: ',
      'Successfully pushed update to client: '
    ];

    this.logInterval = setInterval(() => {
      const type = logTypes[Math.floor(Math.random() * logTypes.length)];
      const msg = logMessages[Math.floor(Math.random() * logMessages.length)];
      const id = Math.floor(Math.random() * 9000) + 1000;

      this.logs.update(currentLogs => {
        const newLogs = [...currentLogs, `${type}: ${msg}${id}`];
        return newLogs.slice(-50);
      });

      setTimeout(() => {
        const container = this.logContainer?.nativeElement;
        if (container) {
          container.scrollTop = container.scrollHeight;
        }
      }, 0);

    }, 1500);
  }

  getCurrentTime(): string {
    return new Date().toLocaleTimeString('en-US', { hour12: false });
  }

  getNavButtonClasses(tab: AppTab): string {
    const base = 'flex items-center w-full px-3 py-2 rounded-lg font-medium transition duration-200';
    const active = 'bg-indigo-600 shadow-lg text-white';
    const inactive = 'text-indigo-200 hover:bg-slate-700 hover:text-white';
    return `${base} ${this.currentTab() === tab ? active : inactive}`;
  }

  getFilterButtonClasses(filter: Ticket['status'] | null): string {
    const base = 'px-4 py-1 text-sm font-semibold rounded-full transition duration-150 ease-in-out border';
    const active = 'bg-indigo-500 text-white border-indigo-600 shadow-md';
    const inactive = 'bg-white text-gray-700 border-gray-300 hover:bg-indigo-50 hover:border-indigo-500';
    return `${base} ${this.currentStatusFilter() === filter ? active : inactive}`;
  }

  getStatusBadgeClasses(status: Ticket['status']): string {
    const base = 'inline-flex items-center px-3 py-0.5 rounded-full text-xs font-medium';
    switch (status) {
      case 'Open':
        return `${base} bg-green-100 text-green-800`;
      case 'In Progress':
        return `${base} bg-yellow-100 text-yellow-800`;
      case 'Closed':
        return `${base} bg-gray-100 text-gray-800`;
      default:
        return '';
    }
  }
}

type AppTab = 'tickets' | 'kBase' | 'logs';

interface Ticket {
  id: number;
  subject: string;
  status: 'Open' | 'In Progress' | 'Closed';
  createdAt: string;
}



