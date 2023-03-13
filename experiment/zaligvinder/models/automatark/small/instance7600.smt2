(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}class/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".class/i\u{0a}")))))
; /\/[0-9A-F]{24}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Ui\u{0a}"))))
; /^\/[a-f0-9]{8}\/[a-f0-9]{8}\/$/iU
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//iU\u{0a}")))))
(check-sat)
