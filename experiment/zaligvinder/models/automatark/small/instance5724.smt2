(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; RequestedLoggedtb\x2Efreeprod\x2EcomHWAESubject\u{3a}adserver\.warezclient\.com
(assert (not (str.in_re X (str.to_re "RequestedLoggedtb.freeprod.comHWAESubject:adserver.warezclient.com\u{0a}"))))
; ^\d{5}$|^\d{5}-\d{4}$
(assert (not (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
