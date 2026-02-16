import SwiftUI

struct ItemDetailView: View {

    @StateObject private var viewModel = ItemDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    let onSave: (Item) -> Void

    var body: some View {
        VStack(spacing: 24) {

            // HEADER
            Text("NEW ITEM")
                .font(.system(size: 22, weight: .bold))

            // TYPE PICKER
            HStack(spacing: 8) {
                ForEach(ItemType.allCases) { type in
                    typeButton(type)
                }
            }

            // TITLE
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(.plain)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.08))
                )

            // SUPPLEMENT FIELDS
            if viewModel.type == .supplement {
                HStack(spacing: 8) {

                    TextField("Amount", text: $viewModel.amountText)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.08))
                        )

                    Menu {
                        ForEach(SupplementUnit.allCases) { unit in
                            Button(unit.displayName) {
                                viewModel.unit = unit
                            }
                        }
                    } label: {
                        Text(viewModel.unit.displayName)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.08))
                            )
                    }
                }
            }

            Spacer()

            // SAVE
            Button("SAVE") {
                if let item = viewModel.buildItem() {
                    onSave(item)
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
    }

    // MARK: - Type Button

    private func typeButton(_ type: ItemType) -> some View {
        let isActive = viewModel.type == type

        return Text(type.title.uppercased())
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(isActive ? .white : .gray)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isActive ? Color.white.opacity(0.15) : Color.clear)
            )
            .onTapGesture {
                viewModel.type = type
            }
    }
}
