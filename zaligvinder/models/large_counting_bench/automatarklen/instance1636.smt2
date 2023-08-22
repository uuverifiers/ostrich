(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /GET\s\/[\w-]{64}\sHTTP\/1/
(assert (not (str.in_re X (re.++ (str.to_re "/GET") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/") ((_ re.loop 64 64) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "HTTP/1/\u{0a}")))))
; from\x3AHost\u{3a}www\.thecommunicator\.net
(assert (not (str.in_re X (str.to_re "from:Host:www.thecommunicator.net\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
