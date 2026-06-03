import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { IncidentDashboardPage } from './features/incidents/pages/IncidentDashboardPage'
import { IncidentDetailsPage } from './features/incidents/pages/IncidentDetailsPage'

export function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/incidents" replace />} />
        <Route path="/incidents" element={<IncidentDashboardPage />} />
        <Route path="/incidents/:id" element={<IncidentDetailsPage />} />
        <Route path="*" element={<Navigate to="/incidents" replace />} />
      </Routes>
    </BrowserRouter>
  )
}