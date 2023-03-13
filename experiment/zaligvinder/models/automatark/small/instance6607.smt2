(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}spx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".spx/i\u{0a}"))))
; XPPreUser-Agent\x3ARemoteYOURsqlStarLoggerclvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (str.to_re "XPPreUser-Agent:RemoteYOURsqlStarLoggerclvompycem/cen.vcn\u{0a}"))))
; /^SpyBuddy\s+Alert/smi
(assert (str.in_re X (re.++ (str.to_re "/SpyBuddy") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Alert/smi\u{0a}"))))
; /^syn\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/syn|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
(check-sat)
