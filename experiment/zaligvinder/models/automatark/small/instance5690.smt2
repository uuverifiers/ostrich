(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Toolbarkl\x2Esearch\x2Eneed2find\x2EcomtvshowticketsToolbarUser-Agent\x3A\.compress
(assert (not (str.in_re X (str.to_re "Toolbarkl.search.need2find.comtvshowticketsToolbarUser-Agent:.compress\u{0a}"))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}")))
; ^\.{1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ".")) (str.to_re "\u{0a}"))))
(check-sat)
