(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <[^>]+>
(assert (str.in_re X (re.++ (str.to_re "<") (re.+ (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}"))))
; ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "6") (re.union (str.to_re "4") (str.to_re "7"))))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}apk/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".apk/i\u{0a}")))))
; /filename=[^\n]*\u{2e}cy3/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cy3/i\u{0a}"))))
; /^\u{2f}nosignal\.jpg\?\d\.\d+$/U
(assert (str.in_re X (re.++ (str.to_re "//nosignal.jpg?") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(check-sat)
