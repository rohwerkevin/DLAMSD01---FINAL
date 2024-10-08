import SwiftUI

struct ContentView: View {
    @State private var selectedDifficulty: GameDifficulty = .easy

    var body: some View {
        NavigationStack {
            ZStack {
                // Hintergrund mit verbessertem Farbverlauf
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 15/255, green: 32/255, blue: 39/255),
                    Color(red: 32/255, green: 58/255, blue: 67/255),
                    Color(red: 44/255, green: 83/255, blue: 100/255)
                ]),
                startPoint: .top,
                endPoint: .bottom)
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // App-Logo oder Symbol
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    // App-Titel mit modernem Font
                    Text("Quiz-App")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)

                    // Kurzer Slogan oder Beschreibung
                    Text("Teste dein Wissen auf spielerische Weise!")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Auswahl des Schwierigkeitsgrades
                    VStack(alignment: .center, spacing: 10) {
                        Text("Wähle deinen Schwierigkeitsgrad")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)

                        // Benutzerdefinierte Schaltflächen für Schwierigkeitsgrade
                        HStack(spacing: 20) {
                            ForEach(GameDifficulty.allCases) { difficulty in
                                DifficultyButton(difficulty: difficulty, isSelected: selectedDifficulty == difficulty)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedDifficulty = difficulty
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Start-Button mit Animation
                    NavigationLink(destination: QuizView(viewModel: QuizViewModel(difficulty: selectedDifficulty))) {
                        Text("Quiz starten")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(red: 0/255, green: 180/255, blue: 219/255),
                                    Color(red: 0/255, green: 131/255, blue: 176/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                    .scaleEffect(1.05)
                    .animation(.easeInOut(duration: 0.8), value: selectedDifficulty)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Zurück") // Navigationstitel gesetzt
            .navigationBarHidden(true)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Benutzerdefinierte View für Schwierigkeitsgrad-Schaltflächen
struct DifficultyButton: View {
    let difficulty: GameDifficulty
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: difficulty.iconName)
                .font(.system(size: 40))
                .foregroundColor(isSelected ? .yellow : .white)

            Text(difficulty.rawValue)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(minWidth: 50, maxWidth: 100)
        }
        .padding()
        .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
        .cornerRadius(15)
        .shadow(radius: isSelected ? 5 : 0)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
