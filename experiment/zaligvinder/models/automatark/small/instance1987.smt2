(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}b\u{2f}shoe\u{2f}[0-9]{3,5}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/shoe/") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}")))
; /\/\d+\.mp3$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re ".mp3/U\u{0a}")))))
(check-sat)
