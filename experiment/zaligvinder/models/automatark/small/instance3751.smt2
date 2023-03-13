(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[\w_.]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; /z\d{1,3}/Pi
(assert (str.in_re X (re.++ (str.to_re "/z") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/Pi\u{0a}"))))
; ^"[^"]+"$
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}")))))
; BysooTBwhenu\x2EcomToolbarWeAgentUser-Agent\u{3a}hasHost\u{3a}toWebupdate\.cgithis
(assert (not (str.in_re X (str.to_re "BysooTBwhenu.com\u{1b}ToolbarWeAgentUser-Agent:hasHost:toWebupdate.cgithis\u{0a}"))))
(check-sat)
