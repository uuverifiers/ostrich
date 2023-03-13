(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-CEGHJ-PR-TW-Z]{1}[A-CEGHJ-NPR-TW-Z]{1}[0-9]{6}[A-DFM]{0,1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "P") (re.range "R" "T") (re.range "W" "Z"))) ((_ re.loop 1 1) (re.union (re.range "A" "C") (str.to_re "E") (str.to_re "G") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "T") (re.range "W" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.union (re.range "A" "D") (str.to_re "F") (str.to_re "M"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}zip/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}"))))
; ^01[0-2]{1}[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Mirar_KeywordContent
(assert (not (str.in_re X (str.to_re "Mirar_KeywordContent\u{13}\u{0a}"))))
; (([\w-]+://?|www[.])[^\s()<>]+)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ":/") (re.opt (str.to_re "/"))) (str.to_re "www.")) (re.+ (re.union (str.to_re "(") (str.to_re ")") (str.to_re "<") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))))
(check-sat)
