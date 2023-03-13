(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$((\d{1})\,\d{1,3}(\,\d{3}))|(\d{1,3}(\,\d{3}))|(\d{1,3})?$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "$") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.opt ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re "\u{0a}"))))))
; Port\s+AgentHost\x3Ainsertkeys\x3Ckeys\u{40}hotpop
(assert (not (str.in_re X (re.++ (str.to_re "Port") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AgentHost:insertkeys<keys@hotpop\u{0a}")))))
; /filename=[^\n]*\u{2e}pls/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pls/i\u{0a}")))))
; /^\/\?[A-Za-z0-9_-]{15}=l3S/U
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "=l3S/U\u{0a}")))))
; /\u{2e}jpm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jpm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
