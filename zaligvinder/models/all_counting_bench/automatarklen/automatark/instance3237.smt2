(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[a-z\d]{1,8}\.exe$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/Ui\u{0a}")))))
; ProtoSubject\u{3a}source\=IncrediFindProjectAgentHost\x3AHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "ProtoSubject:source=IncrediFindProjectAgentHost:Host:Host:\u{0a}"))))
; ^([A-Z]|[a-z]|[0-9])([A-Z]|[a-z]|[0-9]|([A-Z]|[a-z]|[0-9]|(%|&|'|\+|\-|@|_|\.|\ )[^%&'\+\-@_\.\ ]|\.$|([%&'\+\-@_\.]\ [^\ ]|\ [%&'\+\-@_\.][^%&'\+\-@_\.])))+$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " ")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " "))) (str.to_re ".") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (str.to_re " ") (re.comp (str.to_re " "))) (re.++ (str.to_re " ") (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re "."))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
