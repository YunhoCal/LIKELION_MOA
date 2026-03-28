import SwiftUI

struct SubcategorySelectionView: View {
    let selectedCategories: [InterestCategory]
    @Binding var selectedSubcategories: [String]
    let onComplete: () -> Void

    @State private var searchText: String = ""

    // Group subcategories by their parent category
    var groupedSubcategories: [(category: InterestCategory, subcategories: [String])] {
        selectedCategories.map { category in
            let filtered = searchText.isEmpty ? category.subcategories : category.subcategories.filter { sub in
                sub.lowercased().contains(searchText.lowercased())
            }
            return (category: category, subcategories: filtered)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Choose specific interests")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)

                Text("Select topics from your chosen categories (optional)")
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

                TextField("Search topics...", text: $searchText)
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
            if !selectedSubcategories.isEmpty {
                HStack {
                    Text("\(selectedSubcategories.count) topics selected")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))

                    Spacer()

                    Button(action: {
                        selectedSubcategories.removeAll()
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

            // Subcategories by category
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(groupedSubcategories, id: \.category.id) { group in
                        if !group.subcategories.isEmpty {
                            SubcategorySection(
                                category: group.category,
                                subcategories: group.subcategories,
                                selectedSubcategories: $selectedSubcategories
                            )
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGray6))

            // Action buttons
            VStack(spacing: 0) {
                Divider()

                VStack(spacing: 12) {
                    // Skip button
                    Button(action: onComplete) {
                        Text("Skip for now")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                    }

                    // Complete button
                    Button(action: onComplete) {
                        Text(selectedSubcategories.isEmpty ? "Complete Setup" : "Complete Setup (\(selectedSubcategories.count) selected)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                            .cornerRadius(10)
                    }
                }
                .padding(16)
                .background(Color.white)
            }
        }
        .background(Color(.systemGray6))
    }
}

struct SubcategorySection: View {
    let category: InterestCategory
    let subcategories: [String]
    @Binding var selectedSubcategories: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category header
            HStack(spacing: 8) {
                Text(category.emoji)
                    .font(.system(size: 20))

                Text(category.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // Count of selected in this category
                let selectedInCategory = subcategories.filter { sub in
                    selectedSubcategories.contains(category.makeUniqueSubcategory(sub))
                }.count
                if selectedInCategory > 0 {
                    Text("\(selectedInCategory)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)

            // Subcategories
            FlowLayout(spacing: 8) {
                ForEach(subcategories, id: \.self) { subcategory in
                    let uniqueId = category.makeUniqueSubcategory(subcategory)
                    SubcategoryChip(
                        name: subcategory,
                        isSelected: selectedSubcategories.contains(uniqueId),
                        onTap: {
                            toggleSubcategory(subcategory)
                        }
                    )
                }
            }
        }
    }

    private func toggleSubcategory(_ subcategory: String) {
        let uniqueId = category.makeUniqueSubcategory(subcategory)
        if let index = selectedSubcategories.firstIndex(of: uniqueId) {
            selectedSubcategories.remove(at: index)
        } else {
            selectedSubcategories.append(uniqueId)
        }
    }
}

struct SubcategoryChip: View {
    let name: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(name)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray4), lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Flow layout for wrapping chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    SubcategorySelectionView(
        selectedCategories: [
            InterestCategory.allCategories[0],
            InterestCategory.allCategories[4]
        ],
        selectedSubcategories: .constant([]),
        onComplete: {}
    )
}
