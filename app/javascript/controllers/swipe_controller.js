// app/javascript/controllers/swipe_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "card", "feedback"]
  static values = {
    threshold: { type: Number, default: 500 },
    rotationRatio: { type: Number, default: 0.3 }
  }

  connect() {
    this.isDragging = false
    this.startX = 0
    this.currentX = 0
    this.currentCard = this.cardTarget
  }

  startTouch(event) {
    this.isDragging = true
    this.startX = event.touches[0].clientX
    this.currentCard.style.transition = ''
  }

  moveTouch(event) {
    this.currentX = event.touches[0].clientX
    this.handleMove(this.currentX)
  }

  endTouch() {
    this.handleEnd()
  }

  startDrag(event) {
    this.isDragging = true
    this.startX = event.clientX
    this.currentCard.style.transition = ''
    document.addEventListener('mousemove', this.boundMouseMove)
    document.addEventListener('mouseup', this.boundMouseUp)
  }

  moveDrag(event) {
    this.currentX = event.clientX
    this.handleMove(this.currentX)
  }

  endDrag() {
    this.handleEnd()
    document.removeEventListener('mousemove', this.boundMouseMove)
    document.removeEventListener('mouseup', this.boundMouseUp)
  }

  handleMove(x) {
    if (!this.isDragging || !this.currentCard) return

    const deltaX = x - this.startX
    const rotate = deltaX * this.rotationRatioValue

    this.currentCard.style.transform = `translateX(${deltaX}px) rotate(${rotate}deg)`

    this.feedbackTarget.style.opacity = Math.min(Math.abs(deltaX) / 100, 1)
    this.feedbackTarget.style.backgroundColor = deltaX > 0
      ? 'rgba(40, 167, 69, 0.2)'
      : 'rgba(220, 53, 69, 0.2)'
  }

  handleEnd() {
    if (!this.isDragging || !this.currentCard) return

    const deltaX = this.currentX - this.startX
    const cardWidth = this.currentCard.offsetWidth

    if (Math.abs(deltaX) > this.thresholdValue) {
      const button = deltaX > 0
        ? document.getElementById('like-button')
        : document.getElementById('dislike-button')

      this.currentCard.style.transition = 'transform 0.5s ease'
      this.currentCard.style.transform = `translateX(${deltaX > 0 ? cardWidth : -cardWidth}px) rotate(${deltaX * 0.3}deg)`

      setTimeout(() => {
        button.click()
        this.currentCard.remove()
        this.loadNextEvent()
      }, 300)
    } else {
      this.currentCard.style.transition = 'transform 0.3s ease'
      this.currentCard.style.transform = 'translateX(0) rotate(0deg)'
    }

    this.feedbackTarget.style.opacity = 0
    this.isDragging = false
  }

  loadNextEvent() {
    fetch(window.location.pathname, {
      headers: { 'Accept': 'text/javascript' }
    }).then(response => {
      if (!response.ok) console.error('Error loading next event')
    })
  }

  get boundMouseMove() {
    return this.moveDrag.bind(this)
  }

  get boundMouseUp() {
    return this.endDrag.bind(this)
  }
}
