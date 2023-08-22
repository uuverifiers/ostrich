(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}air/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".air/i\u{0a}"))))
; BysooTBwhenu\x2EcomToolbarWeAgentUser-Agent\u{3a}hasHost\u{3a}toWebupdate\.cgithis
(assert (str.in_re X (str.to_re "BysooTBwhenu.com\u{1b}ToolbarWeAgentUser-Agent:hasHost:toWebupdate.cgithis\u{0a}")))
; /^\u{2f}[a-z0-9]{51}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 51 51) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
