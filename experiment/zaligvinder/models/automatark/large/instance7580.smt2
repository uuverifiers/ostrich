(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; DigExtNetBus\x5BStatic
(assert (not (str.in_re X (str.to_re "DigExtNetBus[Static\u{0a}"))))
; BasicPointsHost\x3Anews
(assert (str.in_re X (str.to_re "BasicPointsHost:news\u{0a}")))
; ^http[s]?://([a-zA-Z0-9\-]+\.)*([a-zA-Z]{3,61}|[a-zA-Z]{1,}\.[a-zA-Z]{2})/.*$
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))) (re.union ((_ re.loop 3 61) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "/") (re.* re.allchar) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}cgm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cgm/i\u{0a}"))))
; Travel\s+SystemSleuthserverUser-Agent\u{3a}\x2Fnewsurfer4\x2F
(assert (str.in_re X (re.++ (str.to_re "Travel") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SystemSleuth\u{13}serverUser-Agent:/newsurfer4/\u{0a}"))))
(check-sat)
