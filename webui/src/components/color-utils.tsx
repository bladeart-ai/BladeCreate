export function color(selected: boolean, dragging: boolean) {
  let color = 'bg-secondary/30 hover:bg-pink-100/90'
  if (selected) {
    color = 'bg-pink-400/90'
  } else if (dragging) {
    color = 'bg-pink-100/90'
  }
  return color
}
