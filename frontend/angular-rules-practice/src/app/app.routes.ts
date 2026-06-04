import { Routes } from '@angular/router'
import { IncidentDashboardPageComponent } from './features/incidents/pages/incident-dashboard-page/incident-dashboard-page.component'

export const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'incidents',
  },
  {
    path: 'incidents',
    component: IncidentDashboardPageComponent,
  },
]