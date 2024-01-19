(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <\s*?[^>]+\s*?>
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.comp (str.to_re ">"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">\u{0a}"))))
; /^\/\?[A-Za-z0-9_-]{15}=l3S/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "=l3S/U\u{0a}"))))
; /\/setup_b\.asp\?prj=\d\u{26}pid=[^\r\n]*\u{26}mac=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//setup_b.asp?prj=") (re.range "0" "9") (str.to_re "&pid=") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
