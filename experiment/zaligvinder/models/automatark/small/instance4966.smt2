(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+Host\x3A\u{7c}roogoo\u{7c}Testiufilfwulmfi\u{2f}riuf\.lio
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:|roogoo|Testiufilfwulmfi/riuf.lio\u{0a}")))))
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h")))))))
; User-Agent\u{3a}\soffers\x2Ebullseye-network\x2Ecom\d+FTPsearch\.dropspam\.com
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "offers.bullseye-network.com") (re.+ (re.range "0" "9")) (str.to_re "FTPsearch.dropspam.com\u{0a}")))))
(check-sat)
