(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}js\u{3f}[a-zA-Z0-9]{9,20}=Mozilla\u{2f}/UGi
(assert (str.in_re X (re.++ (str.to_re "/.js?") ((_ re.loop 9 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=Mozilla//UGi\u{0a}"))))
; Host\x3A.*Hello\x2E.*Referer\x3AToolbarCurrent\x3BCIA
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Hello.") (re.* re.allchar) (str.to_re "Referer:ToolbarCurrent;CIA\u{0a}")))))
; /filename=[^\n]*\u{2e}vwr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vwr/i\u{0a}")))))
(check-sat)
