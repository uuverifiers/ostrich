(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3Atwfofrfzlugq\u{2f}eve\.qduuid=ppcdomain\x2Eco\x2EukGuardedReferer\x3AreadyLOGUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:twfofrfzlugq/eve.qduuid=ppcdomain.co.ukGuardedReferer:readyLOGUser-Agent:\u{0a}"))))
; SI\|Server\|\d+informationWinInetEvilFTPOSSProxy\x5Chome\/lordofsearch
(assert (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.range "0" "9")) (str.to_re "informationWinInetEvilFTPOSSProxy\u{5c}home/lordofsearch\u{0a}"))))
; Hello\x2E\s+ovplrichfind\x2EcomCookie\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Hello.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ovplrichfind.comCookie:\u{0a}")))))
; ^(100(\.0{0,2}?)?$|([1-9]|[1-9][0-9])(\.\d{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "100") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (str.to_re "0"))))) (re.++ (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.range "1" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
