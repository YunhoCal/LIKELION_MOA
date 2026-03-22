import SwiftUI

struct CategorySelectionView: View {
    @Binding var selectedCategories: [InterestCategory]
    let onContinue: () -> Void

    @State private var searchText: String = ""

    var filteredCategories: [InterestCategory] {
        if searchText.isEmpty {
            return InterestCategory.allCategories
        }
        return InterestCategory.allCategories.filter { category in
            category.name.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("What are you interested in?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)

                Text("Choose categories that interest you (select at least one)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.white)

            // Search bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))

                TextField("Search interests...", text: $searchText)
                    .font(.system(size: 14))

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            // Selected count
            if !selectedCategories.isEmpty {
                HStack {
                    Text("\(selectedCategories.count) selected")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                    Spacer()

                    Button(action: {
                        selectedCategories.removeAll()
                    }) {
                        Text("Clear all")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white)
            }

            // Categories grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(filteredCategories) { category in
                        CategoryCard(
                            category: category,
                            isSelected: selectedCategories.contains(where: { $0.id == category.id }),
                            onTap: {
                                toggleCategory(category)
                            }
                        )
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGray6))

            // Continue button
            VStack(spacing: 0) {
                Divider()

                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedCategories.isEmpty ? Color.gray : Color(red: 0.4, green: 0.3, blue: 0.8))
                        .cornerRadius(10)
                }
                .disabled(selectedCategories.isEmpty)
                .padding(16)
                .background(Color.white)
            }
        }
        .background(Color(.systemGray6))
    }

    private func toggleCategory(_ category: InterestCategory) {
        if let index = selectedCategories.firstIndex(where: { $0.id == category.id }) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(category)
        }
    }
}

struct CategoryCard: View {
    let category: InterestCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Emoji
                Text(category.emoji)
                    .font(.system(size: 40))

                // Name
                Text(category.name)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 36)

                // Subcategory count
                Text("\(category.subcategories.count) topics")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8).opacity(0.1) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color.clear, lineWidth: 2)
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategorySelectionView(
        selectedCategories: .constant([]),
        onContinue: {}
    )
}
