(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\d{2,4}\.xap$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re ".xap/U\u{0a}")))))
; [A-Za-z]{1,2}[\d]{1,2}[A-Za-z]{0,1}
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}addin/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".addin/i\u{0a}")))))
(check-sat)
