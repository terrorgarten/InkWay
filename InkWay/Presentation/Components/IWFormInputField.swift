import SwiftUI

struct IWFormInputField: View {
    var placeholder: String
    @Binding var value: String
    var label: String? = nil
    var isSecure: Bool = false
    var isMultiline: Bool = false
    var color: Color = Color.accentColor

    var body: some View {
        VStack(alignment: .leading) {
            if let label = label {
                Text(label)
                    .fontWeight(.medium)
                    .foregroundColor(color)
            }
            if isMultiline  {
                TextEditor(text: $value)
                    .frame(minHeight: 100, maxHeight: 100)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(color, lineWidth: 1)
                    )
                    .autocorrectionDisabled()
            } else {
                if isSecure {
                    SecureField(placeholder, text: $value)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(color, lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                } else {
                    TextField(placeholder, text: $value)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(color, lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                }
            }
        }
        .padding(.horizontal)
    }
}

struct FormInputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IWFormInputField(placeholder: "Enter your username", value: .constant(""), label: "Username")
                .padding(.vertical)

            IWFormInputField(placeholder: "Choose your password", value: .constant(""), label: "Password", isSecure: true, color: Color("SecondaryColor"))
                .padding(.vertical)
            
            IWFormInputField(placeholder: "Input without label", value: .constant(""))
                .padding(.vertical)
            
            // Usage for user bio with multiline input
            IWFormInputField(placeholder: "Enter your bio", value: .constant(""), label: "Bio", isMultiline: true)
                .padding(.vertical)
        }
    }
}
