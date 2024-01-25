import { ClusterStatusDropdown, ShrinkDiv, TopBar, UserDropdown } from './layout-top'

export function NavBar({ userDropDown = true }: { userDropDown?: boolean }) {
  return (
    <TopBar>
      <ShrinkDiv />
      <ClusterStatusDropdown />
      {userDropDown && <UserDropdown />}
    </TopBar>
  )
}
