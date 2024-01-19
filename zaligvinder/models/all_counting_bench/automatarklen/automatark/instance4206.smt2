(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; wonder\s*([^$]*)\s*with
(assert (not (str.in_re X (re.++ (str.to_re "wonder") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re "$"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "with\u{0a}")))))
; <title>(.*?)</title>
(assert (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}"))))
; ^([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4})$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 7) (re.++ ((_ re.loop 0 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ":"))) (re.union (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f")))) (str.to_re "\u{0a}")))))
; CUSTOM\swww\x2Elocators\x2Ecomas\x2Estarware\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.comas.starware.com\u{0a}")))))
; ShadowNet\dsearchreslt\sTROJAN-Host\x3AYWRtaW46cGFzc3dvcmQ
(assert (str.in_re X (re.++ (str.to_re "ShadowNet") (re.range "0" "9") (str.to_re "searchreslt") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "TROJAN-Host:YWRtaW46cGFzc3dvcmQ\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
