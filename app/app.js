const passages = [
  "Practice makes progress, and every small step improves your typing speed and confidence.",
  "Typing with focus and rhythm helps you stay accurate while you build stronger habits every day.",
  "The best way to improve is to type regularly, stay calm, and keep your eyes on the text.",
  "A good typist learns to balance speed with accuracy, because careful practice leads to better results.",
  "Typing is a skill that grows with patience, consistency, and a little bit of daily effort."
];

const timerEl = document.getElementById("timer");
const wpmEl = document.getElementById("wpm");
const accuracyEl = document.getElementById("accuracy");
const passageEl = document.getElementById("typing-passage");
const typingInput = document.getElementById("typing-input");
const startBtn = document.getElementById("start-btn");
const resetBtn = document.getElementById("reset-btn");
const resultMessage = document.getElementById("result-message");

let timeLeft = 60;
let timerId = null;
let gameStarted = false;
let correctChars = 0;
let totalTypedChars = 0;
let currentPassage = "";

function selectRandomPassage() {
  const randomIndex = Math.floor(Math.random() * passages.length);
  currentPassage = passages[randomIndex];
  passageEl.textContent = currentPassage;
}

function updateTimerDisplay() {
  timerEl.textContent = timeLeft;
}

function updateStats() {
  const elapsedSeconds = 60 - timeLeft;
  const minutes = elapsedSeconds > 0 ? elapsedSeconds / 60 : 0;

  let wpm = 0;
  if (minutes > 0) {
    wpm = Math.round(correctChars / 5 / minutes);
  }

  let accuracy = 100;
  if (totalTypedChars > 0) {
    accuracy = Math.round((correctChars / totalTypedChars) * 100);
  }

  wpmEl.textContent = wpm;
  accuracyEl.textContent = `${accuracy}%`;
}

function finishGame(finishedEarly) {
  clearInterval(timerId);
  gameStarted = false;
  typingInput.disabled = true;

  const elapsedSeconds = 60 - timeLeft;
  const minutes = elapsedSeconds > 0 ? elapsedSeconds / 60 : 1 / 60;
  const finalWpm = Math.max(0, Math.round(correctChars / 5 / minutes));
  const finalAccuracy = totalTypedChars > 0 ? Math.round((correctChars / totalTypedChars) * 100) : 100;

  if (finishedEarly) {
    resultMessage.textContent = `Excellent! You finished with ${finalWpm} WPM and ${finalAccuracy}% accuracy.`;
  } else {
    resultMessage.textContent = `Time's up! Final score: ${finalWpm} WPM, ${finalAccuracy}% accuracy.`;
  }

  resultMessage.style.color = "#0f9f6e";
  typingInput.blur();
}

function startGame() {
  if (gameStarted) {
    return;
  }

  gameStarted = true;
  timeLeft = 60;
  correctChars = 0;
  totalTypedChars = 0;
  typingInput.value = "";
  typingInput.disabled = false;
  typingInput.focus();

  resultMessage.textContent = "Keep typing!";
  resultMessage.style.color = "#0f9f6e";

  updateTimerDisplay();
  updateStats();

  clearInterval(timerId);
  timerId = setInterval(() => {
    timeLeft -= 1;
    updateTimerDisplay();

    if (timeLeft <= 0) {
      finishGame(false);
    }
  }, 1000);
}

function resetGame() {
  clearInterval(timerId);
  gameStarted = false;
  timeLeft = 60;
  correctChars = 0;
  totalTypedChars = 0;

  typingInput.value = "";
  typingInput.disabled = true;
  resultMessage.textContent = "";
  resultMessage.style.color = "#0f9f6e";

  selectRandomPassage();
  updateTimerDisplay();
  wpmEl.textContent = "0";
  accuracyEl.textContent = "100%";
}

function handleTyping() {
  if (!gameStarted) {
    return;
  }

  const typedText = typingInput.value;
  totalTypedChars = typedText.length;
  correctChars = 0;

  for (let i = 0; i < typedText.length; i += 1) {
    if (typedText[i] === currentPassage[i]) {
      correctChars += 1;
    }
  }

  updateStats();

  if (typedText === currentPassage) {
    finishGame(true);
  }
}

startBtn.addEventListener("click", startGame);
resetBtn.addEventListener("click", resetGame);
typingInput.addEventListener("input", handleTyping);

selectRandomPassage();
updateTimerDisplay();
wpmEl.textContent = "0";
accuracyEl.textContent = "100%";
typingInput.disabled = true;
