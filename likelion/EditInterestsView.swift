import SwiftUI

struct EditInterestsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var currentStep: EditStep = .categories
    @State private var selectedCategories: [InterestCategory] = []
    @State private var selectedSubcategories: [String] = []
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var hasLoadedInitialData: Bool = false

    enum EditStep {
        case categories
        case subcategories
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                Group {
                    switch currentStep {
                    case .categories:
                        CategorySelectionView(
                            selectedCategories: $selectedCategories,
                            onContinue: {
                                currentStep = .subcategories
                            }
                        )

                    case .subcategories:
                        SubcategorySelectionView(
                            selectedCategories: selectedCategories,
                            selectedSubcategories: $selectedSubcategories,
                            onComplete: {
                                saveInterests()
                            }
                        )
                    }
                }
                .disabled(isLoading)

                // Loading overlay
                if isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)

                        Text("Updating interests...")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Cancel")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                loadExistingInterests()
            }
        }
    }

    private func loadExistingInterests() {
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true

        if let user = appState.currentUser {
            // Load selected categories
            if let categoryIds = user.interestCategories {
                selectedCategories = categoryIds.compactMap { categoryId in
                    InterestCategory.allCategories.first { $0.id == categoryId }
                }
            }

            // Load selected subcategories
            if let subcategories = user.interestSubcategories {
                selectedSubcategories = subcategories
            }
        }
    }

    private func saveInterests() {
        guard let userId = appState.currentUser?.id else { return }

        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let categoryIds = selectedCategories.map { $0.id }
                let response = try await APIService.shared.updateInterests(
                    userId: userId,
                    categories: categoryIds,
                    subcategories: selectedSubcategories
                )

                // Update the current user with new interests
                await MainActor.run {
                    if let user = appState.currentUser {
                        appState.currentUser = User(
                            id: user.id,
                            email: user.email,
                            name: user.name,
                            university: user.university,
                            major: user.major,
                            graduationYear: user.graduationYear,
                            bio: user.bio,
                            interestCategories: categoryIds.isEmpty ? nil : categoryIds,
                            interestSubcategories: selectedSubcategories.isEmpty ? nil : selectedSubcategories
                        )
                    }
                    appState.token = response.token
                    dismiss()
                }

            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

#Preview {
    EditInterestsView()
        .environmentObject(AppState())
}
