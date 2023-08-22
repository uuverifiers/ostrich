(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; activityHWAEHost\u{3a}MyWayServidor\x2EHANDYEmail
(assert (not (str.in_re X (str.to_re "activityHWAEHost:MyWayServidor.\u{13}HANDYEmail\u{0a}"))))
; /\u{00}{7}\u{53}\u{00}{3}\u{16}.{8}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "S") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "\u{16}") ((_ re.loop 8 8) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}")))))
; Pass-Onseqepagqfphv\u{2f}sfdcargo=dnsgpstool\u{2e}globaladserver\u{2e}com
(assert (str.in_re X (str.to_re "Pass-Onseqepagqfphv/sfdcargo=dnsgpstool.globaladserver.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
