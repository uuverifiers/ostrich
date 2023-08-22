(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (vi(v))?d
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "viv")) (str.to_re "d\u{0a}")))))
; SI\|Server\|\s+OSSProxy\x5Chome\/lordofsearch%3fAuthorization\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "SI|Server|\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "OSSProxy\u{5c}home/lordofsearch%3fAuthorization:\u{0a}")))))
; ^\$[+-]?([0-9]+|[0-9]{1,3}(,[0-9]{3})*)(\.[0-9]{1,2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; LIST\]SpamBlockerUtilityTry2FindBasicHost\x3AUser-Agent\x3AAcmeprotocolSpy
(assert (str.in_re X (str.to_re "LIST]SpamBlockerUtilityTry2FindBasicHost:User-Agent:AcmeprotocolSpy\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
