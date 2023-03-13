(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Fimages\x2Fnocache\x2Ftr\x2Fgca\x2Fm\.gif\?
(assert (not (str.in_re X (str.to_re "/images/nocache/tr/gca/m.gif?\u{0a}"))))
; ([Cc][Hh][Aa][Nn][Dd][Aa][Nn].*?)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "C") (str.to_re "c")) (re.union (str.to_re "H") (str.to_re "h")) (re.union (str.to_re "A") (str.to_re "a")) (re.union (str.to_re "N") (str.to_re "n")) (re.union (str.to_re "D") (str.to_re "d")) (re.union (str.to_re "A") (str.to_re "a")) (re.union (str.to_re "N") (str.to_re "n")) (re.* re.allchar))))
; /\u{2e}jfif([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jfif") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^((\d{5}-?\d{4})|(\d{5})|([A-Za-z]\d[A-Za-z]\s?\d[A-Za-z]\d))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
(check-sat)
