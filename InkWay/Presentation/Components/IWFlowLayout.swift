
//
//  IWFlowLayout.swift
//  InkWay
//
//  Created by terrorgarten on 15.03.2024.
//

import SwiftUI

// Component reused from https://blog.logrocket.com/implementing-tags-swiftui/
struct IWFlowLayout<Data, RowContent>: View where Data: RandomAccessCollection, RowContent: View, Data.Element: Identifiable, Data.Element: Hashable {
  @State private var height: CGFloat = .zero

  private var data: Data
  private var spacing: CGFloat
  private var rowContent: (Data.Element) -> RowContent

  public init(_ data: Data, spacing: CGFloat = 5, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) {
    self.data = data
    self.spacing = spacing
    self.rowContent = rowContent
  }

  var body: some View {
    GeometryReader { geometry in
      content(in: geometry)
        .background(viewHeight(for: $height))
    }
    .frame(height: height)
  }

  private func content(in geometry: GeometryProxy) -> some View {
    var bounds = CGSize.zero

    return ZStack {
      ForEach(data) { item in
        rowContent(item)
          .padding(.all, spacing)
          .alignmentGuide(VerticalAlignment.center) { dimension in
            let result = bounds.height

            if let firstItem = data.first, item == firstItem {
              bounds.height = 0
            }
            return result
          }
          .alignmentGuide(HorizontalAlignment.center) { dimension in
            if abs(bounds.width - dimension.width) > geometry.size.width {
              bounds.width = 0
              bounds.height -= dimension.height
            }

            let result = bounds.width

            if let firstItem = data.first, item == firstItem {
              bounds.width = 0
            } else {
              bounds.width -= dimension.width
            }
            return result
          }
      }
    }
  }

  private func viewHeight(for binding: Binding<CGFloat>) -> some View {
    GeometryReader { geometry -> Color in
      let rect = geometry.frame(in: .local)

      DispatchQueue.main.async {
        binding.wrappedValue = rect.size.height
      }
      return .clear
    }
  }
}


struct FlowLayout_Previews: PreviewProvider {
    static var previews: some View {
        IWFlowLayout(sampleTags) { tag in
            IWTag(text: tag.text)
        }
        .padding()
    }
}
