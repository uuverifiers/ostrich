(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; pjpoptwql\u{2f}rlnj\sPG=SPEEDBARadblock\x2Elinkz\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "pjpoptwql/rlnj") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PG=SPEEDBARadblock.linkz.com\u{0a}")))))
; Referer\x3A\s+www\u{2e}proventactics\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.proventactics.com\u{0a}"))))
; ^(02\d\s?\d{4}\s?\d{4})|((01|05)\d{2}\s?\d{3}\s?\d{4})|((01|05)\d{3}\s?\d{5,6})|((01|05)\d{4}\s?\d{4,5})$
(assert (str.in_re X (re.union (re.++ (str.to_re "02") (re.range "0" "9") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "1") (str.to_re "5"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 6) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "1") (str.to_re "5"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re "0") (re.union (str.to_re "1") (str.to_re "5"))))))
; /filename=[^\n]*\u{2e}mks/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mks/i\u{0a}"))))
; (8[^0]\d|8\d[^0]|[0-79]\d{2})-\d{3}-\d{4}
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "8") (re.comp (str.to_re "0")) (re.range "0" "9")) (re.++ (str.to_re "8") (re.range "0" "9") (re.comp (str.to_re "0"))) (re.++ (re.union (re.range "0" "7") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
