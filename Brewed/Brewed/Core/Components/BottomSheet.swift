//
//  BottomSheet.swift
//  Brewed
//
//  Draggable bottom sheet. Detents: medium, large, full.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let detents: Set<PresentationDetent>
    let content: Content
    
    init(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: () -> Content
    ) {
        _isPresented = isPresented
        self.detents = detents
        self.content = content()
    }
    
    var body: some View {
        content
            .presentationDetents(detents)
            .presentationDragIndicator(.visible)
            .presentationBackground(.regularMaterial)
    }
}

/// Wrapper to use as a sheet modifier
struct BrewedBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detents: Set<PresentationDetent>
    let sheetContent: SheetContent
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent
                    .presentationDetents(detents)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.regularMaterial)
            }
        }
}

extension View {
    func brewedSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: isPresented) {
            content()
                .presentationDetents(detents)
                .presentationDragIndicator(.visible)
                .presentationBackground(.regularMaterial)
        }
    }
}
