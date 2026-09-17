-- ============================================================
-- QRUP İŞİ — DATA KEYFİYYƏTİ AUDİTİ
-- HR sistemində uyğunsuzluqları tapmaq üçün 4 sorğu
-- ============================================================

-- 1. Şöbəsi təyin edilməyən işçiləri tapın
SELECT e.first_name, e.last_name
FROM hr.employees e
LEFT JOIN hr.departments d
ON e.department_id = d.department_id
WHERE d.department_id IS NULL;


-- 2. Heç bir işçisi olmayan şöbələri sadalayın
SELECT d.department_id, d.department_name
FROM hr.departments d
LEFT JOIN hr.employees e
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;


-- 3. FULL OUTER JOIN ilə hər iki problemi BİR sorğuda göstərin
SELECT e.first_name,
       e.employee_id,
       e.last_name,
       d.department_id,
       d.department_name
FROM hr.employees e
FULL OUTER JOIN hr.departments d
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL
   OR d.department_id IS NULL;


-- 4. Rəhbəri olmayan işçini tapın (SELF JOIN)
SELECT e.first_name,
       e.last_name,
       e.employee_id,
       m.first_name AS menecer_adi,
       m.last_name AS menecer_soyadi
FROM hr.employees e
LEFT JOIN hr.employees m
ON e.manager_id = m.employee_id
WHERE e.manager_id IS NULL;


-- ============================================================
-- TƏQDİMAT ÜÇÜN QEYDLƏR
-- ============================================================
-- Səbəb: Bu uyğunsuzluqlar adətən məlumat daxil edilərkən yaranır —
--        yeni işçi əlavə edilib, amma department_id təyin olunmayıb,
--        və ya yeni şöbə yaradılıb, amma hələ işçi təyin edilməyib.
--
-- Təsir: Şöbə üzrə hesabatlarda (məs. "hər şöbənin işçi sayı") bu
--        sətirlər səhv nəticə verə bilər. INNER JOIN istifadə
--        edilsəydi, bu sətirlər tamamilə görünməz olardı və hesabat
--        natamam olardı.
--
-- Həll: HR sistemində department_id sahəsi məcburi (NOT NULL) edilə
--       bilər, yeni işçi qeydiyyatında validasiya tələb oluna bilər.
