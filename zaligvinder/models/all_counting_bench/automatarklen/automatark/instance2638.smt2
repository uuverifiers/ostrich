(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?java\=[0-9]{2,6}$/U
(assert (str.in_re X (re.++ (str.to_re "/?java=") ((_ re.loop 2 6) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; Host\x3A.*User-Agent\u{3a}\sRequest
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "User-Agent:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Request\u{0a}")))))
; RequestedLoggedtb\x2Efreeprod\x2EcomHWAESubject\u{3a}adserver\.warezclient\.com
(assert (str.in_re X (str.to_re "RequestedLoggedtb.freeprod.comHWAESubject:adserver.warezclient.com\u{0a}")))
; ^(\d{5}-\d{4}|\d{5})$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
