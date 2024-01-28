export function color(selected: boolean = false, dragging: boolean = false) {
  let color = 'bg-secondary/30 hover:bg-pink-100/90'
  if (selected) {
    color = 'bg-pink-400/90'
  } else if (dragging) {
    color = 'bg-pink-100/90'
  }
  return color
}
export function borderColor(selected: boolean = false) {
  let color = ''
  if (selected) {
    color = 'border-pink-400/90'
  } else {
    color = 'border-pink-100/90'
  }
  return color
}
