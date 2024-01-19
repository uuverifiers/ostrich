(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((8|\+38)-?)?(\(?044\)?)?-?\d{3}-?\d{2}-?\d{2}$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+38")) (re.opt (str.to_re "-")))) (re.opt (re.++ (re.opt (str.to_re "(")) (str.to_re "044") (re.opt (str.to_re ")")))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; jsp\s+pjpoptwql\u{2f}rlnj[^\n\r]*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "jsp") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "pjpoptwql/rlnj") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; \x2Fpagead\x2Fads\?search2\.ad\.shopnav\.com\x2F9899\x2Fsearch\x2Fresults\.php
(assert (not (str.in_re X (str.to_re "/pagead/ads?search2.ad.shopnav.com/9899/search/results.php\u{0a}"))))
; /filename=[^\n]*\u{2e}mp4/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mp4/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
