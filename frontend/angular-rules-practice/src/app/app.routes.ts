import { Routes } from '@angular/router'
import { IncidentDashboardPageComponent } from './features/incidents/pages/incident-dashboard-page/incident-dashboard-page.component'
import { IncidentDetailsPageComponent } from './features/incidents/pages/incident-details-page/incident-details-page.component'

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
  {
    path: 'incidents/:id',
    component: IncidentDetailsPageComponent,
  },
]