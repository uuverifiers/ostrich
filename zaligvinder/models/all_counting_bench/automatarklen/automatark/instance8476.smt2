(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SpyBuddySubject\x3Astats\u{2e}drivecleaner\u{2e}com
(assert (not (str.in_re X (str.to_re "SpyBuddySubject:stats.drivecleaner.com\u{13}\u{0a}"))))
; ^([\(]{1}[0-9]{3}[\)]{1}[\.| |\-]{0,1}|^[0-9]{3}[\.|\-| ]?)?[0-9]{3}(\.|\-| )?[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) (re.opt (re.union (str.to_re ".") (str.to_re "|") (str.to_re " ") (str.to_re "-")))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "|") (str.to_re "-") (str.to_re " ")))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}mp3([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mp3") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; filename=\u{22}Subject\u{3a}www\x2Eadoptim\x2Ecomreport\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "filename=\u{22}Subject:www.adoptim.comreport/bar_pl/chk.fcgi\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
