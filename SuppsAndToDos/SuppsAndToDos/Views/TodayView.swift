import SwiftUI

struct TodayView: View {

    @EnvironmentObject private var viewModel: TodayViewModel

    @State private var showAddMenu = false
    @State private var showAddItemSheet = false
    @State private var showNoteEditor = false

    private var todayNote: DayNote? {
        viewModel.note(for: Date())
    }

    var body: some View {
        ZStack {

            // MARK: - Main Content
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    segmentControl
                        .padding(.top, 12)

                    heroHeader

                    if let next = viewModel.nextItem {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NEXT")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)

                            Text(next.title)
                                .font(.system(size: 22, weight: .bold))
                        }
                    }

                    Divider().opacity(0.4)

                    VStack(spacing: 14) {
                        ForEach(viewModel.openStatuses) { status in
                            if let item = viewModel.item(for: status) {
                                ItemRowView(
                                    item: item,
                                    status: status,
                                    onDone: {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            viewModel.markDone(statusID: status.id)
                                        }
                                    }
                                )
                            }
                        }
                    }

                    dailyNoteSection

                    if let milestone = activeMilestone {
                        MilestoneCardView(milestone: milestone)
                    }

                    Spacer(minLength: 80)
                }
                .padding()
            }

            // MARK: - Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    Button {
                        showAddMenu = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 58, height: 58)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.black)
        .foregroundColor(.white)

        // MARK: - Add Menu
        .confirmationDialog("Add", isPresented: $showAddMenu) {

            Button("Add Todo / Supplement") {
                showAddItemSheet = true
            }

            Button("Add Note") {
                showNoteEditor = true
            }

            Button("Cancel", role: .cancel) {}
        }

        // MARK: - Add Item Sheet
        .sheet(isPresented: $showAddItemSheet) {
            ItemDetailView { item in
                viewModel.addItem(item)
            }
        }

        // MARK: - Note Editor
        .sheet(isPresented: $showNoteEditor) {
            NoteEditorView(date: Date())
                .environmentObject(viewModel)
        }
    }

    // MARK: - Daily Note Section

    private var dailyNoteSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("DAILY NOTE")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                Spacer()

                Button(todayNote == nil ? "Add" : "Edit") {
                    showNoteEditor = true
                }
                .font(.system(size: 13, weight: .medium))
            }

            Button {
                showNoteEditor = true
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    if let note = todayNote {
                        Text(note.text)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .lineLimit(3)
                    } else {
                        Text("Write a note for today…")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.06))
                )
            }
        }
    }

    // MARK: - Segment Control

    private var segmentControl: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.08))

            HStack(spacing: 0) {
                segmentItem(title: "SUPPS", category: .supplement)
                segmentItem(title: "TODOS", category: .todo)
            }
        }
        .frame(height: 44)
    }

    private func segmentItem(title: String, category: ItemCategory) -> some View {
        let isActive = viewModel.selectedCategory == category

        return ZStack {
            if isActive {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.18))
                    .padding(4)
            }

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isActive ? .white : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                viewModel.selectedCategory = category
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        HStack(spacing: 24) {

            VStack(alignment: .leading, spacing: 6) {
                Text("TODAY")
                    .font(.system(size: 26, weight: .bold))

                Text(Date(), style: .date)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                Text(progressLabel)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        Color.white,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Text("\(Int(viewModel.progress * 100))%")
                    .font(.system(size: 18, weight: .bold))
            }
            .frame(width: 90, height: 90)
        }
    }

    private var progressLabel: String {
        viewModel.progress == 1.0
            ? "All done 🎉"
            : viewModel.progress > 0
                ? "Keep going"
                : "Let's start"
    }

    private var activeMilestone: Milestone? {
        viewModel.milestones.first {
            !$0.isCompleted &&
            (
                $0.relatedItemType == nil ||
                $0.relatedItemType?.matches(viewModel.selectedCategory) == true
            )
        }
    }
}
