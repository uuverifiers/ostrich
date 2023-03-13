(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[2-9][0-8]\d[2-9]\d{6}$
(assert (str.in_re X (re.++ (re.range "2" "9") (re.range "0" "8") (re.range "0" "9") (re.range "2" "9") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; WinCrashcomHost\x3Atid\x3D\u{25}toolbar\x5Fid4\u{2e}8\u{2e}4
(assert (str.in_re X (str.to_re "WinCrashcomHost:tid=%toolbar_id4.8.4\u{0a}")))
(check-sat)
