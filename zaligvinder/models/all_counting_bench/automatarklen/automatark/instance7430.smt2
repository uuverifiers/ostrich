(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; HXDownload\s+Host\x3AArcadeHourspjpoptwql\u{2f}rlnjFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "HXDownload") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:ArcadeHourspjpoptwql/rlnjFrom:\u{0a}"))))
; Host\x3A.*Peer.*Host\x3ABasicurl=http\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Peer") (re.* re.allchar) (str.to_re "Host:Basicurl=http:\u{1b}\u{0a}"))))
; ^[+-]? *(\$)? *((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{0,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (re.opt (str.to_re "$")) (re.* (str.to_re " ")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A\u{25}2EResultsUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "Host:%2EResultsUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
