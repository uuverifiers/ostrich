(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/jdb\/inf\.php\?id=[a-f0-9]{32}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//jdb/inf.php?id=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; \d{2}.?\d{3}.?\d{3}/?\d{4}-?\d{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \x2Frss\d+answer\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
