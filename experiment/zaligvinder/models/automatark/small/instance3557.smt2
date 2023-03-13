(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; offers\x2Ebullseye-network\x2Ecom\s+news[^\n\r]*WatcherUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "offers.bullseye-network.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WatcherUser-Agent:\u{0a}"))))
; [\u{80}-\xFF]
(assert (not (str.in_re X (re.++ (re.range "\u{80}" "\u{ff}") (str.to_re "\u{0a}")))))
; ^([A-Z]{2}\s?(\d{2})?(-)?([A-Z]{1}|\d{1})?([A-Z]{1}|\d{1})?( )?(\d{4}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.opt (re.union ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (re.union ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9"))))))
; \u{7c}roogoo\u{7c}Testiufilfwulmfi\u{2f}riuf\.lioHeaders
(assert (str.in_re X (str.to_re "|roogoo|Testiufilfwulmfi/riuf.lioHeaders\u{0a}")))
(check-sat)
