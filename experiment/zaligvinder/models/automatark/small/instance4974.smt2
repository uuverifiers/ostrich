(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Za-z]|[A-Za-z][0-9]*|[0-9]*[A-Za-z])+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}caf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".caf/i\u{0a}"))))
; /\/pte\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (str.in_re X (re.++ (str.to_re "//pte.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(check-sat)
