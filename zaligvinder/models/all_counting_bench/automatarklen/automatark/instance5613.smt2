(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Easpx\s+www\x2Ealtnet\x2EcomSubject\x3A
(assert (str.in_re X (re.++ (str.to_re ".aspx") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.altnet.com\u{1b}Subject:\u{0a}"))))
; /\.(jsp|html)\?[^\r\n]*PG=SPEEDBAR/Ui
(assert (str.in_re X (re.++ (str.to_re "/.") (re.union (str.to_re "jsp") (str.to_re "html")) (str.to_re "?") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "PG=SPEEDBAR/Ui\u{0a}"))))
; ((\(\d{3,4}\)|\d{3,4}-)\d{4,9}(-\d{1,5}|\d{0}))|(\d{4,12})
(assert (not (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "(") ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 4 9) (re.range "0" "9")) (re.union (re.++ (str.to_re "-") ((_ re.loop 1 5) (re.range "0" "9"))) ((_ re.loop 0 0) (re.range "0" "9")))) (re.++ ((_ re.loop 4 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /\u{2e}xsl([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.xsl") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
