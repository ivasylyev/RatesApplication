using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Services;

/// <summary>
///     <see cref="IRuleRepository" />
/// </summary>
/// <remarks>
/// ВРЕМЕННЫЙ сервис, возвращающий жестко зашитые правила конвертации шабалона СУГ НХТК
/// При развитии продукта необходимо получать правила из сервиса работы с даными Sibur.Digital.Svt.Nkhtk.Data
/// </remarks>
public class HardcodedRuleRepository : IRuleRepository
{
    /// <summary>
    /// Словарь соттвтетствия жд станций исходного шаблона и кодов СВТ
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> NodesDictionary;

    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т Для СУГ
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> SugDistanceDictionary;

    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т Для НБ
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> NbDistanceDictionary;

    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т
    /// Для  СПТ Тобольск ТК + БГС
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> SPTTKBGS_DistanceDictionary;


    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т
    /// Для СПБТ-Нягань для Листов ПБТ и Пропилен; + СПТ Тобольск ТК + БГС
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> SPBT_PBT_Propilen_TKBGSDistanceDictionary;


    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т
    /// Для СПБТ-Нягань для Листов Бутилен (Бутен);
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> SPBT_Butilen_DistanceDictionary;



    /// <summary>
    /// Словарь соотвтетствия расстояния между  жд станциями и "Чистая" ВС, руб./т
    /// Для СПБТ-Нягань для Листов Бутадиен;
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> SPBT_Butadien_DistanceDictionary;

    /// <summary>
    /// Общий Словарь соответствия между продуктами и их группами
    /// </summary>
    private static readonly List<RuleDictionaryItemDto> AllProductsDictionary;

    static HardcodedRuleRepository()
    {
        NodesDictionary = ReadNodeDictionaryFromExcel();

        SugDistanceDictionary = ReadDistanceDictionaryFromExcel(3);
        NbDistanceDictionary = ReadDistanceDictionaryFromExcel(4);
        SPBT_PBT_Propilen_TKBGSDistanceDictionary = ReadDistanceDictionaryFromExcel(5);
        SPBT_Butadien_DistanceDictionary = ReadDistanceDictionaryFromExcel(6);
        SPBT_Butilen_DistanceDictionary = ReadDistanceDictionaryFromExcel(7);
        SPTTKBGS_DistanceDictionary = ReadDistanceDictionaryFromExcel(8);

        AllProductsDictionary = Sug11ProductsDictionary
            .Union(Sug12ProductsDictionary)
            .Union(Sug13ProductsDictionary)
            .Union(Sug20ProductsDictionary)
            .Union(Sug31ProductsDictionary)
            .Union(Sug321ProductsDictionary)
            .Union(Sug322ProductsDictionary)
            .Union(Sug323ProductsDictionary)
            .Union(ShfluProductsDictionary)
            .Union(Nb11ProductsDictionary)
            .Union(Nb12ProductsDictionary)
            .Union(Nb13ProductsDictionary)
            .Union(Nb14ProductsDictionary)
            .Union(Nb15ProductsDictionary)
            .Union(Nb16ProductsDictionary)
            .Union(Nb17ProductsDictionary)
            .Union(Nb211ProductsDictionary)
            .Union(Nb212ProductsDictionary)
            .Union(Nb221ProductsDictionary)
            .Union(Nb222ProductsDictionary)
            .Union(Nb30ProductsDictionary)
            .Union(Nb50ProductsDictionary)
            .Union(Nb70ProductsDictionary)
            .Union(Nb80ProductsDictionary)
            .Union(TKRFProductsDictionary)
            .Union(SPBT_ProductsDictionary)
            .Union(SPTTKBGSProductsDictionary)
            .Union(KauchukProductsDictionary)
            .Union(PEPPProductsDictionary)
            .ToList();
    }

    /// <summary>
    /// 06 – СУГ-1
    /// </summary>
    public List<int> Sug10Worksheets
        => new()
        {
            1001, // "Ставки"
            1002, // "Ставки без охраны"
            1003 // "Спецставка"
        };

    /// <summary>
    /// 06 – СУГ-2 - фракция пент изопент
    /// </summary>
    public List<int> Sug20Worksheets
        => new()
        {
            2001 // "Ставки"
        };

    /// <summary>
    /// 06 – СУГ-3 - бутадиен
    /// </summary>
    public List<int> Sug31Worksheets
        => new()
        {
            3101, // "Ставки"
            3102 // "СпецСтавки"
        };

    /// <summary>
    /// 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ
    /// </summary>
    public List<int> Sug32Worksheets
        => new()
        {
            3201, // "Пропилен, изобутилен "
            3202, // "изобутилен до 720 км со скидкой"
            3203 // "Бутилен, изопрен, БДФ "
        };

    /// <summary>
    /// 06 – ШФЛУ
    /// </summary>
    public List<int> ShfluWorksheets
        => new()
        {
            5001, // "повагонная "
            5002, // "более 20"
            5003, // "ПОМ"
            5004 // "Спецставка"
        };


    /// <summary>
    /// 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022
    /// </summary>
    public List<int> Nb10Worksheets
        => new()
        {
            6001, //Ставки
            6002, // Ставки со скидкой на 720 км
            6003, //МТБЭ Сургут
            6004, //МТБЭ Сахалин МАЙ 2022
            6005, //Стирол
            6006, //Гликоли
            6007 //Гликоли КЛН  МАЙ
        };

    /// <summary>
    /// 06 – НБ-2 - ЖПП СПТ и т.д
    /// </summary>
    public List<int> Nb21Worksheets
        => new()
        {
            7101, //ставки 2022
            7102 //Сахалин 2022 ИНДИКАТИВ МАЙ!!!
        };

    /// <summary>
    /// 06 – НБ-2 - химия
    /// </summary>
    public List<int> Nb22Worksheets
        => new()
        {
            7201, //ставки 2022
            7202 //Ставки со скидкой на расст.  ап
        };


    /// <summary>
    /// 06 – НБ-3 - БГС
    /// </summary>
    public List<int> Nb30Worksheets
        => new()
        {
            8001, //БГС
            8002, //БГС  более 20
            8003 //ПОМ
        };


    /// <summary>
    /// 06 – НБ-5 Натрия гидроксид, каустики
    /// </summary>
    public List<int> Nb50Worksheets
        => new()
        {
            10001 //ставки 2022
        };


    /// <summary>
    /// 06 – НБ-7
    /// </summary>
    public List<int> Nb70Worksheets
        => new()
        {
            11001 //ставки 2022
        };

    /// <summary>
    /// 06 – НБ-8
    /// </summary>
    public List<int> Nb80Worksheets
        => new()
        {
            12001 //ставки 2022
        };

    /// <summary>
    /// 06 – ТК РФ
    /// </summary>
    public List<int> TKRFWorksheets
        => new()
        {
            15001, //ТК РФ
            15002 //ТК РФ  Биклянь Форвард ТС
        };




    /// <summary>
    /// СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
    /// </summary>
    public List<int> SPBTWorksheets
        => new()
        {
            20001, //2022 ПБТ
            20002, //2022 Пропилен
            20003, //2022  Пропилен экспорт
            20004, //2022 Бутадиен
            20005 // 22022 Бутилен (Бутен)
        };


    /// <summary>
    /// СПТ Тобольск ТК + БГС
    /// </summary>
    public List<int> SPTTKBGSWorksheets
        => new()
        {
            21001, //СПТ
            21002 //СПТ экспорт
        };


    /// <summary>
    /// КАУЧУКи с ВС
    /// </summary>
    public List<int> KauchukWorksheets
        => new()
        {
            22001, //Каучуки руб | ваг АТЛАНТ
            22002, //Каучуки руб | ваг РСТ
        };


    /// <summary>
    /// ПЭ-ПП с ВС ИНДИКАТИВ
    /// </summary>
    public List<int> PEPPWorksheets
        => new()
        {
            23001, //ПЭ-ПП ПГК 122-175
            23002, //ПЭ-ПП ПГК 150-175
            23003, //ПЭ-ПП АНТАНТ
            23004, //ПЭ-ПП РСТ
            23005 // ПЭ-ПП Евросиб
        };

    private static List<RuleDictionaryItemDto> Sug11ProductsDictionary
        => new()
        {
            // СУГ-1 - Ставки
            new RuleDictionaryItemDto("1088401", "T6"),
            new RuleDictionaryItemDto("818654", "T24"),
            new RuleDictionaryItemDto("735853", "T24"),
            new RuleDictionaryItemDto("1194872", "T34"),
            new RuleDictionaryItemDto("1196667", "T24")
        };

    /// <summary>
    /// СУГ-1 - Ставки без охраны
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug12ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("726073", "T26"),
            new RuleDictionaryItemDto("978768", "T6"),
            new RuleDictionaryItemDto("1198596", "T33"),
            new RuleDictionaryItemDto("1197026", "T26"),
            new RuleDictionaryItemDto("1197413", "T26"),
            new RuleDictionaryItemDto("215147", "T22"),
            new RuleDictionaryItemDto("1197212", "T26"),
            new RuleDictionaryItemDto("1196896", "T26"),
            new RuleDictionaryItemDto("1182289", "T26"),
            new RuleDictionaryItemDto("1184722", "T25"),
            new RuleDictionaryItemDto("1206057", "T25")
        };

    /// <summary>
    /// СУГ-1 - Спецставка
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug13ProductsDictionary
        => new() { new RuleDictionaryItemDto("978768", "T6") };

    /// <summary>
    /// 06 – СУГ-2 - фракция пент изопент
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug20ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("949721", "T22"),
            new RuleDictionaryItemDto("662545", "T22")
        };

    /// <summary>
    /// 06 – СУГ-3 - бутадиен
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug31ProductsDictionary
        => new() { new RuleDictionaryItemDto("742969", "T5") };

    /// <summary>
    /// 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  ---- Пропилен, изобутилен
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug321ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("978767", "T26"),
            new RuleDictionaryItemDto("1053729", "T25"),
            new RuleDictionaryItemDto("369037", "T11")
        };


    /// <summary>
    /// 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  ---- изобутилен до 720 км со скидкой
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug322ProductsDictionary
        => new() { new RuleDictionaryItemDto("369037", "T11") };


    /// <summary>
    /// 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  ---- Бутилен, изопрен, БДФ
    /// </summary>
    private static List<RuleDictionaryItemDto> Sug323ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("492195", "T12"),
            new RuleDictionaryItemDto("668077", "T26"),
            new RuleDictionaryItemDto("728551", "") // нет кода, так и должно быть
        };

    /// <summary>
    /// 06 – ШФЛУ
    /// </summary>
    private static List<RuleDictionaryItemDto> ShfluProductsDictionary
        => new() { new RuleDictionaryItemDto("1129223", "T36") };

    /// <summary>
    /// НБ-1 Ставки
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb11ProductsDictionary
        => new()
        {
            new("337649", "T26"),
            new("801633", "T36"),
            new("343336", "T19"),
            new("996943", "T26"),
            new("381473", "T26"),
            new("388088", "T26"),
            new("437119", "T26"),
            new("549716", "T26"),
            new("573024", "T26"),
            new("586791", "T26"),
            new("710117", "T26"),
            new("429178", "T4"),
            new("313745", "T19"),
            new("375534", "T19"),
            new("457881", "T19"),
            new("991886", "T19"),
            new("897818", "T19"),
            new("339909", "T26"),
            new("386495", "T26"),
            new("415581", "T26"),
            new("624229", "T19"),
            new("365688", "T40"),
            new("546480", "T40"),
            new("702944", "T40"),
            new("972108", "T40"),
            new("900549", "T19"),
            new("963009", ""),
            new("825146", "T26"),
            new("685916", "T26"),
            new("346026", "T3"),
            new("1184679", ""),
            new("1182518", "T26"),
            new("1182642", "T26"),
            new("1209282", "T26")
        };

    /// <summary>
    /// НБ-1 Ставки со скидкой на 720 км
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb12ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("198835", "T40"),
            new RuleDictionaryItemDto("1182517", "T26"),
            new RuleDictionaryItemDto("969046", "T37"),
            new RuleDictionaryItemDto("1204844", "T26"),
            new RuleDictionaryItemDto("415581", "T26"),
            new RuleDictionaryItemDto("991886", "T19"),
            new RuleDictionaryItemDto("1182518", "T26"),
            new RuleDictionaryItemDto("897818", "T19")
        };
    
    /// <summary>
    /// НБ-1 МТБЭ Сургут
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb13ProductsDictionary
        => new() { new RuleDictionaryItemDto("991643", "T18") };

    /// <summary>
    /// НБ-1 МТБЭ Сахалин МАЙ 2022
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb14ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("616866", "T19"),
            new RuleDictionaryItemDto("279160", "T4")
        };

    /// <summary>
    /// НБ-1 МТБЭ Стирол
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb15ProductsDictionary
        => new() { new RuleDictionaryItemDto("338824", "T19") };

    /// <summary>
    /// НБ-1 МТБЭ Гликоли
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb16ProductsDictionary
        => new() { new RuleDictionaryItemDto("991831", "T19") };

    /// <summary>
    /// НБ-1 МТБЭ Гликоли КЛН  МАЙ
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb17ProductsDictionary
        => new() { new RuleDictionaryItemDto("991831", "T19") };

    /// <summary>
    /// НБ-2 06 – НБ-2 - ЖПП СПТ и т.д  --- ставки 2022
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb211ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("773362", "T26"),
            new RuleDictionaryItemDto("1210592", "T26"),
            new RuleDictionaryItemDto("1182294", "T29"),
            new RuleDictionaryItemDto("1182302", "T26"),
            new RuleDictionaryItemDto("1003156", "T10"),
            new RuleDictionaryItemDto("801770", "T26"),
            new RuleDictionaryItemDto("185621", "T26"),
            new RuleDictionaryItemDto("1188810", "T10"),
            new RuleDictionaryItemDto("713976", "T10")
        };

    /// <summary>
    /// 53 - 06 – НБ-2 - ЖПП СПТ и т.д Сахалин 2022 ИНДИКАТИВ МАЙ!!!
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb212ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("1182294", "T29"),
            new RuleDictionaryItemDto("713976", "T10")
        };
    
    /// <summary>
    /// 53 - 06 – НБ-2 - химия  -- ставки 2022
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb221ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("428674", "T9"),
            new RuleDictionaryItemDto("350620", "T27"),
            new RuleDictionaryItemDto("767776", "T19"),
            new RuleDictionaryItemDto("402872", "T32"),
            new RuleDictionaryItemDto("958869", "T26"),
            new RuleDictionaryItemDto("339435", "T26"),
            new RuleDictionaryItemDto("339428", "T26"),
            new RuleDictionaryItemDto("697932", ""), // нет кода, так и должно быть
            new RuleDictionaryItemDto("337640", "T32"),
            new RuleDictionaryItemDto("369630", "T26")
        };

    /// <summary>
    /// 53 - 06 – НБ-2 - химия   -- Ставки со скидкой на расст.  ап
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb222ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("428674", "T9"),
            new RuleDictionaryItemDto("350620", "T27"),
            new RuleDictionaryItemDto("339435", "T26"),
            new RuleDictionaryItemDto("337640", "T32")
        };
      
    /// <summary>
    /// 06 – НБ-3 - БГС
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb30ProductsDictionary
        => new() { new RuleDictionaryItemDto("214018", "T26") };

    /// <summary>
    /// 06 – НБ-5 Натрия гидроксид, каустики
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb50ProductsDictionary
        => new() { new RuleDictionaryItemDto("1194297", "T20") };

    /// <summary>
    /// 06 – НБ-7
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb70ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("412522", "T14"),
            new RuleDictionaryItemDto("1184726", "T26"),
        };

    /// <summary>
    /// 06 – НБ-8
    /// </summary>
    private static List<RuleDictionaryItemDto> Nb80ProductsDictionary
        => new() { new RuleDictionaryItemDto("1184797", "") };

    /// <summary>
    /// 06 – ТК РФ
    /// </summary>
    private static List<RuleDictionaryItemDto> TKRFProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("343336", "T19"),
            new RuleDictionaryItemDto("900549", "T19"),
            new RuleDictionaryItemDto("1185200", "T26"),
            new RuleDictionaryItemDto("1080493", "T26"),
            new RuleDictionaryItemDto("338824", "T19"),
            new RuleDictionaryItemDto("991831", "T19"),
            new RuleDictionaryItemDto("198835", "T40"),
            new RuleDictionaryItemDto("1194963", "T40"),
            new RuleDictionaryItemDto("742969", "T5"),
            new RuleDictionaryItemDto("346026", "T3"),
            new RuleDictionaryItemDto("1209282", "T26")
        };

    /// <summary>
    /// 06 – ТК РФ
    /// </summary>
    private static List<RuleDictionaryItemDto> TKRFProductNamesDictionary
        => new()
        {
            new RuleDictionaryItemDto("спирты", "343336"),
            new RuleDictionaryItemDto("Спирты", "343336"),
            new RuleDictionaryItemDto("Бутилакрилат", "900549"),
            new RuleDictionaryItemDto("бутилакрилат", "900549"),
            new RuleDictionaryItemDto("Дициклопентадиена (ЕТСНГ711162)", "1185200"),
            new RuleDictionaryItemDto("ДОФ / ДОТФ", "1080493"),
            new RuleDictionaryItemDto("стирол", "338824"),
            new RuleDictionaryItemDto("Стирол", "338824"),
            new RuleDictionaryItemDto("Гликоли", "991831"),
            new RuleDictionaryItemDto("гликоли", "991831"),
            new RuleDictionaryItemDto("Кислота 2-этилгексановая (ЕТСНГ724266)", "198835"),
            new RuleDictionaryItemDto("Кислота 2-этилгексановая (ЕТСНГ724266) ", "198835"),
            new RuleDictionaryItemDto("Винилацетат ингибированный (ЕТСНГ 725112)", "1194963"),
            new RuleDictionaryItemDto("Бутадиен", "742969"),
            new RuleDictionaryItemDto("Бензол", "346026"),
            new RuleDictionaryItemDto("Гексен-1", "1209282"),
            new RuleDictionaryItemDto("бутадиен", "742969"),
            new RuleDictionaryItemDto("бензол", "346026"),
            new RuleDictionaryItemDto("гексен-1", "1209282")
        };


    /// <summary>
    /// 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
    /// </summary>
    ///
    /// 
    private static List<RuleDictionaryItemDto> SPBT_ProductsDictionary
        => SPBT_Butadien_ProductsDictionary
            .Union(SPBT_Propilen_ProductsDictionary)
            .Union(SPBT_PBT_ProductsDictionary)
            .Union(SPBT_Butilen_ProductsDictionary)
            .ToList();
    private static List<RuleDictionaryItemDto> SPBT_Butadien_ProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("742969", "T5"),

        };

    private static List<RuleDictionaryItemDto> SPBT_Propilen_ProductsDictionary
        => new()
        {

            new RuleDictionaryItemDto("1053729", "T25"),

        };
    private static List<RuleDictionaryItemDto> SPBT_PBT_ProductsDictionary
        => new()
        {
 
            new RuleDictionaryItemDto("1196667", "T24"),
    
        };
    private static List<RuleDictionaryItemDto> SPBT_Butilen_ProductsDictionary
        => new()
        {

            new RuleDictionaryItemDto("668077", "T26")
        };
   
    /// <summary>
    /// 06 СПТ Тобольск ТК + БГС
    /// </summary>
    private static List<RuleDictionaryItemDto> SPTTKBGSProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("1182294", "T29")
        };

    /// <summary>
    /// 06 КАУЧУКи
    /// </summary>
    private static List<RuleDictionaryItemDto> KauchukProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("1209656", "T14")
        };

    /// <summary>
    ///06 - ПЭ-ПП
    /// </summary>
    private static List<RuleDictionaryItemDto> PEPPProductsDictionary
        => new()
        {
            new RuleDictionaryItemDto("159683", "T23"),
            new RuleDictionaryItemDto("1214791", "T23")
        };

    /// <summary>
    /// Словарь соответсвия кодов продуктов с кодами ЕТСНГ
    /// </summary>
    private static List<RuleDictionaryItemDto> ProductEtsngDictionary
        => new()
        {
            new RuleDictionaryItemDto("1198596", "226182"),
            new RuleDictionaryItemDto("1197413", "226201"),
            new RuleDictionaryItemDto("1197212", "226229"),
            new RuleDictionaryItemDto("616866", "725589"),
            new RuleDictionaryItemDto("1188810", "213002"),
            new RuleDictionaryItemDto("773362", "213002"),
            new RuleDictionaryItemDto("1210592", "213002"),
            new RuleDictionaryItemDto("1184797", "214058"),
            new RuleDictionaryItemDto("337649", "215099"),
            new RuleDictionaryItemDto("801770", "215099"),
            new RuleDictionaryItemDto("369630", "215169"),
            new RuleDictionaryItemDto("662545", "215188"),
            new RuleDictionaryItemDto("949721", "215188"),
            new RuleDictionaryItemDto("713976", "215210"),
            new RuleDictionaryItemDto("1003156", "215210"),
            new RuleDictionaryItemDto("1182289", "226248"),
            new RuleDictionaryItemDto("1182302", ""),
            new RuleDictionaryItemDto("1182294", "225298"),
            new RuleDictionaryItemDto("1182294", "225298"),
            new RuleDictionaryItemDto("726073", "226002"),
            new RuleDictionaryItemDto("1088401", "226040"),
            new RuleDictionaryItemDto("214018", "226002"),
            new RuleDictionaryItemDto("1196896", ""),
            new RuleDictionaryItemDto("818654", "226125"),
            new RuleDictionaryItemDto("1194872", "226163"),
            new RuleDictionaryItemDto("1197026", "226197"),
            new RuleDictionaryItemDto("1196667", ""),
            new RuleDictionaryItemDto("735853", "226267"),
            new RuleDictionaryItemDto("1196667", "226267"),
            new RuleDictionaryItemDto("1184722", "226271"),
            new RuleDictionaryItemDto("1206057", "226286"),
            new RuleDictionaryItemDto("801633", "226290"),
            new RuleDictionaryItemDto("1129223", "226290"),
            new RuleDictionaryItemDto("1209656", "451063"),
            new RuleDictionaryItemDto("343336", "721003"),
            new RuleDictionaryItemDto("343336", "721003"),
            new RuleDictionaryItemDto("159683", "461366"),
            new RuleDictionaryItemDto("1214791", "461385"),
            new RuleDictionaryItemDto("996943", "481232"),
            new RuleDictionaryItemDto("1194297", "482146"),
            new RuleDictionaryItemDto("742969", "488123"),
            new RuleDictionaryItemDto("1200075", "488509"),
            new RuleDictionaryItemDto("339428", "531003"),
            new RuleDictionaryItemDto("215147", "215188"),
            new RuleDictionaryItemDto("728551", ""),
            new RuleDictionaryItemDto("381473", "711001"),
            new RuleDictionaryItemDto("388088", "711001"),
            new RuleDictionaryItemDto("437119", "711001"),
            new RuleDictionaryItemDto("549716", "711001"),
            new RuleDictionaryItemDto("573024", "711001"),
            new RuleDictionaryItemDto("586791", "711001"),
            new RuleDictionaryItemDto("710117", "711001"),
            new RuleDictionaryItemDto("978767", "711001"),
            new RuleDictionaryItemDto("279160", "711054"),
            new RuleDictionaryItemDto("429178", "711054"),
            new RuleDictionaryItemDto("668077", "711073"),
            new RuleDictionaryItemDto("338824", "711088"),
            new RuleDictionaryItemDto("369037", "711209"),
            new RuleDictionaryItemDto("369037", "711209"),
            new RuleDictionaryItemDto("492195", "711232"),
            new RuleDictionaryItemDto("1053729", "711374"),
            new RuleDictionaryItemDto("1053729", "711374"),
            new RuleDictionaryItemDto("185621", "711529"),
            new RuleDictionaryItemDto("958869", "711529"),
            new RuleDictionaryItemDto("428674", "712220"),
            new RuleDictionaryItemDto("313745", "721003"),
            new RuleDictionaryItemDto("375534", "721003"),
            new RuleDictionaryItemDto("457881", "721003"),
            new RuleDictionaryItemDto("991886", "721164"),
            new RuleDictionaryItemDto("897818", "721639"),
            new RuleDictionaryItemDto("339909", "723009"),
            new RuleDictionaryItemDto("386495", "723009"),
            new RuleDictionaryItemDto("415581", "723009"),
            new RuleDictionaryItemDto("624229", "724069"),
            new RuleDictionaryItemDto("198835", "725004"),
            new RuleDictionaryItemDto("198835", "725004"),
            new RuleDictionaryItemDto("365688", "725004"),
            new RuleDictionaryItemDto("546480", "725004"),
            new RuleDictionaryItemDto("702944", "725004"),
            new RuleDictionaryItemDto("972108", "725004"),
            new RuleDictionaryItemDto("900549", "725061"),
            new RuleDictionaryItemDto("900549", "725061"),
            new RuleDictionaryItemDto("963009", "725220"),
            new RuleDictionaryItemDto("991643", "725502"),
            new RuleDictionaryItemDto("978768", "226093"),
            new RuleDictionaryItemDto("350620", "742003"),
            new RuleDictionaryItemDto("767776", "752251"),
            new RuleDictionaryItemDto("697932", ""),
            new RuleDictionaryItemDto("339435", "753004"),
            new RuleDictionaryItemDto("825146", "753004"),
            new RuleDictionaryItemDto("1182365", "753447"),
            new RuleDictionaryItemDto("337640", "754327"),
            new RuleDictionaryItemDto("402872", "754327"),
            new RuleDictionaryItemDto("685916", "757005"),
            new RuleDictionaryItemDto("1080493", "757005"),
            new RuleDictionaryItemDto("338824", "711088"),
            new RuleDictionaryItemDto("346026", "711035"),
            new RuleDictionaryItemDto("969046", "711681"),
            new RuleDictionaryItemDto("991831", "721677"),
            new RuleDictionaryItemDto("1184679", ""),
            new RuleDictionaryItemDto("338824", "711088"),
            new RuleDictionaryItemDto("346026", "711035"),
            new RuleDictionaryItemDto("412522", "451006"),
            new RuleDictionaryItemDto("668077", "711073"),
            new RuleDictionaryItemDto("742969", "488123"),
            new RuleDictionaryItemDto("991831", "721677"),
            new RuleDictionaryItemDto("1182517", "711463"),
            new RuleDictionaryItemDto("1182518", "711459"),
            new RuleDictionaryItemDto("1182642", "711459"),
            new RuleDictionaryItemDto("1184726", ""),
            new RuleDictionaryItemDto("1185200", ""),
            new RuleDictionaryItemDto("1194963", "725004"),
            new RuleDictionaryItemDto("1204844", "725339"),
            new RuleDictionaryItemDto("1209282", "711092"),
            new RuleDictionaryItemDto("1209282", "711092")
        };

    private async Task<List<RuleDto>> GetRulesAsync()
    {
        await Task.CompletedTask;

        var sugWorksheets = Sug10Worksheets
            .Union(Sug20Worksheets)
            .Union(Sug31Worksheets)
            .Union(Sug32Worksheets)
            .Union(ShfluWorksheets)
            .ToList();

        var nbWorksheets = Nb10Worksheets
            .Union(Nb21Worksheets)
            .Union(Nb22Worksheets)
            .Union(Nb30Worksheets)
            .Union(Nb50Worksheets)
            .Union(Nb70Worksheets)
            .Union(Nb80Worksheets)
            .ToList();

        var allWorksheets = sugWorksheets
            .Union(nbWorksheets)
            .Union(TKRFWorksheets)
            .Union(SPBTWorksheets)
            .Union(SPTTKBGSWorksheets)
            .Union(KauchukWorksheets)
            .Union(PEPPWorksheets)
            .ToList();

        var rules = new List<RuleDto>
        {
            // 4  - all
            new()
            {
                RuleId = 400,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "LoadedRFSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Тариф",
                    "Тариф РЖД",
                    "Тариф по РЖД",
                    "Тариф, руб/т"
                }),
                SourceWorksheets = allWorksheets
            },
            // 4 - all
            // Добавляем значение из колонки "Охрана груза."
            new()
            {
                RuleId = 401,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "LoadedRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "Охрана груза.",
                    "Охрана"
                }),
                RuleOperator = RuleOperator.Plus,
                SourceWorksheets = allWorksheets
            },

            // 4 - НБ-1 - МТБЭ Сахалин
            // Применяем третье преобразование только для вкладки "МТБЭ Сахалин"
            // Добавляем значение из колонки "Тариф Сахалин"
            new()
            {
                RuleId = 402,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "LoadedRFSize",
                SourceEntity =  new RuleEntityDto(new List<string> { "Тариф Сахалин" }),
                RuleOperator = RuleOperator.Plus,
                SourceWorksheets = new List<int> { 6004 }
            },

            // 4 - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 403,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "LoadedRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 5 all
            new()
            {
                RuleId = 500,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "LoadedRFCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },

            // 8 - СУГ
            // Применяем первое преобразование - копирование из колонки исходного шаблона "ВС со СЗ Реализация"
            // в колонку СВТ "EmptyRFSize"
            new()
            {
                RuleId = 800,
                DestinationColumn = "EmptyRFSize",
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "ВС со СЗ Реализация",
                    "ВС со СЗ"
                }),
                SourceWorksheets = sugWorksheets
            },
            // 8 - СУГ
            // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
            // Словарное значение, зависящее от "S, км"
            new()
            {
                RuleId = 801,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto(new List<string> { "S, км" }),
                Dictionary = new RuleDictionaryDto(SugDistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = sugWorksheets
            },
            // 8 - НБ
            // + СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
            // +  СПТ Тобольск ТК + БГС
            // Применяем первое преобразование - копирование из колонки исходного шаблона "ВС или Вагонная составляющая"
            // в колонку СВТ "EmptyRFSize"
            new()
            {
                RuleId = 810,
                DestinationColumn = "EmptyRFSize",
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ВС",
                    "ВС, руб/т",
                    "Вагонная составляющая"
                }),
                SourceWorksheets = nbWorksheets.
                    Union(SPBTWorksheets)
                    .Union(SPTTKBGSWorksheets)
                    .ToList()
            },
            // 8 - НБ
            // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
            // Словарное значение, зависящее от "S, км"
            new()
            {
                RuleId = 811,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto(  new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(NbDistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = nbWorksheets
            },

            // 8 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутадиен
            new()
            {
                RuleId = 812,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_Butadien_DistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = new List<int>
                {
                    20004, //2022 Бутадиен
                }

            },
            // 8 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутилен
            new()
            {
                RuleId = 813,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_Butilen_DistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = new List<int>
                {
                    20005 // 22022 Бутилен (Бутен)
                }

            },



            // 8- 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
            // ПБТ +  Пропилен
            // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
            // Словарное значение, зависящее от "S, км"
            new()
            {
                RuleId = 814,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_PBT_Propilen_TKBGSDistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = new List<int>
                    {
                        20001, //2022 ПБТ
                        20002, //2022 Пропилен
                        20003 //2022  Пропилен экспорт
                    }
            },

            // 8- 06 СПТ Тобольск ТК + БГС
            // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
            // Словарное значение, зависящее от "S, км"
            new()
            {
                RuleId = 815,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPTTKBGS_DistanceDictionary),
                RuleOperator = RuleOperator.Minus,
                SourceWorksheets = SPTTKBGSWorksheets
            },

            // 8 - ТК РФ + Каучуки + ПЭ ПП 
            // первое преобразование - копирование из колонки "Возврат" исходного шаблона  в колонку СВТ "EmptyRFSize"
            new()
            {
                RuleId = 830,
                DestinationColumn = "EmptyRFSize",
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                SourceEntity = new RuleEntityDto( new List<string> { "Возврат", "Возврат по РЖД" }),
                SourceWorksheets = TKRFWorksheets
                    .Union(KauchukWorksheets)
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 8  - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // второе преобразование  - делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 831,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EmptyRFSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 9 - all
            new()
            {
                RuleId = 900,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "EmptyRFCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 12 - СУГ 
            new()
            {
                RuleId = 1200,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity =  new RuleEntityDto(new List<string> { "S, км" }),
                Dictionary = new RuleDictionaryDto(SugDistanceDictionary),
                SourceWorksheets = sugWorksheets
            },
            // 12 - НБ
            new()
            {
                RuleId = 1210,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(NbDistanceDictionary),
                SourceWorksheets = nbWorksheets
            },

            // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутадиен
            new()
            {
                RuleId = 1211,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_Butadien_DistanceDictionary),
                SourceWorksheets = new List<int>
                    {
                        20004, //2022 Бутадиен
                    }
                    
            },
            // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутилен
            new()
            {
                RuleId = 1212,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_Butilen_DistanceDictionary),
                SourceWorksheets = new List<int>
                {
                    20005 // 22022 Бутилен (Бутен)
                }

            },
    
            // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен  лист ПБТ +  ПБТ
            new()
            {
                RuleId = 1213,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity =new RuleEntityDto( new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPBT_PBT_Propilen_TKBGSDistanceDictionary),
                SourceWorksheets = new List<int>
                    {
                        20001, //2022 ПБТ
                        20002, //2022 ПБТ
                        20003 //2022  Пропилен экспорт
                    }
            },

            // 12 -  СПТ Тобольск ТК + БГС
            new()
            {
                RuleId = 1214,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "S, км",
                    "S всего, км",
                    "S РФ, км",
                    "Общее расстояние , км. "
                }),
                Dictionary = new RuleDictionaryDto(SPTTKBGS_DistanceDictionary),
                SourceWorksheets = SPTTKBGSWorksheets
            },
            
            // 12 - ТК РФ
            // +  КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // Применяем первое преобразование - копирование из колонки исходного шаблона "Услуга" или  "Вагонная составляющая."
            // в колонку СВТ "ProvisionTransportSize"
            new ()
            {
                RuleId = 1220,
                DestinationColumn = "ProvisionTransportSize",
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                SourceEntity = new RuleEntityDto(new List<string> { "Услуга" , "Вагонная составляющая."}),
                SourceWorksheets = TKRFWorksheets
                    .Union(KauchukWorksheets)
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 12 - ТК РФ
            // Применяем второе преобразование - добавляем к  колонке СВТ "ProvisionTransportSize"
            // значение из колонки НХТК  "Рентабельность"
            new()
            {
                RuleId = 1221,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto(new List<string> { "Рентабельность" }),
                RuleOperator = RuleOperator.Plus,
                SourceWorksheets = TKRFWorksheets
            },

            // 12  - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // второе преобразование  - делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 1225,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "ProvisionTransportSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },
           

            // 13  - all
            new()
            {
                RuleId = 1300,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "ProvisionTransportCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 16  - all
            new()
            {
                RuleId = 1600,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "TEFromSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ТЭ отправ.",
                    "ГО отправ.",
                    "ТЭ отпр.",
                    "ГО отправления",
                    "ТЭ отправления",
                    "ТЭ"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },

            // 16 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 1610,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "TEFromSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 17  - all
            new()
            {
                RuleId = 1700,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TEFromCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 17  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
            // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
            // и при применении оператора IsNull к значению  "" и "RUB" берется ""
            // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
            // при отсутсвии словарных значений берется NULL, и резултат применнения
            // оператора IsNull к значению  NULL и "RUB" берется "RUB"
            new()
            {
                RuleId = 1701,
                RuleKind = RuleKind.SourceColumnCopyDictionaryOnly,
                RuleOperator = RuleOperator.IsNull,
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ТЭ отправ.",
                    "ГО отправ.",
                    "ТЭ отпр.",
                    "ГО отправления",
                    "ТЭ отправления",
                    "ТЭ"
                }),
                DestinationColumn = "TEFromCurrency",
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
            // 18 - all
            new()
            {
                RuleId = 1800,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "PNPFromSize",
                SourceEntity =new RuleEntityDto( new List<string>
                {
                    "ПНП отправ.",
                    "ПНП отправл.",
                    "ПНП отправления",
                    "ПНП"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },

            
            // 18 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 1810,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "PNPFromSize",
                SourceEntity =new RuleEntityDto(new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },
            // 19 - all
            new()
            {
                RuleId = 1900,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "PNPFromCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 19  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
            // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
            // и при применении оператора IsNull к значению  "" и "RUB" берется ""
            // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
            // при отсутсвии словарных значений берется NULL, и резултат применнения
            // оператора IsNull к значению  NULL и "RUB" берется "RUB"
            new()
            {
                RuleId = 1901,
                RuleKind = RuleKind.SourceColumnCopyDictionaryOnly,
                RuleOperator = RuleOperator.IsNull,
                SourceEntity =new RuleEntityDto(new List<string>
                {
                    "ПНП отправ.",
                    "ПНП отправл.",
                    "ПНП отправления",
                    "ПНП"
                }),
                DestinationColumn = "PNPFromCurrency",
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
            // 20 - all
            new()
            {
                RuleId = 2000,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "TEToSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ТЭ назнач.",
                    "ГО назнач.",
                    "ТЭ назн.",
                    "ГО назначения"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
            // 20 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 2010,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "TEToSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },
            // 21 - all
            new()
            {
                RuleId = 2100,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TEToCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 21  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
            // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
            // и при применении оператора IsNull к значению  "" и "RUB" берется ""
            // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
            // при отсутсвии словарных значений берется NULL, и резултат применнения
            // оператора IsNull к значению  NULL и "RUB" берется "RUB"
            new()
            {
                RuleId = 2101,
                RuleKind = RuleKind.SourceColumnCopyDictionaryOnly,
                RuleOperator = RuleOperator.IsNull,
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ТЭ назнач.",
                    "ГО назнач.",
                    "ТЭ назн.",
                    "ГО назначения"
                }),
                DestinationColumn = "TEToCurrency",
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
            // 22  - all
            new()
            {
                RuleId = 2200,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "PNPToSize",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "ПНП назнач.",
                    "ПНП назначен.",
                    "ПНП назначения"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
            // 22 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            // делим на "Вес груза, брутто, т"
            new()
            {
                RuleId = 2210,
                RuleKind = RuleKind.SourceColumnCopy,
                RuleDataType = RuleType.Number,
                DestinationColumn = "PNPToSize",
                SourceEntity =new RuleEntityDto( new List<string>
                {
                    "Вес груза, брутто, т"
                }),
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                RuleOperator = RuleOperator.Divide,
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },
            // 23 - all
            new()
            {
                RuleId = 2300,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "PNPToCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 23 - all - затирает пустой строкой те значения в колонке валюты, для которых число в
            // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
            // и при применении оператора IsNull к значению  "" и "RUB" берется ""
            // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
            // при отсутсвии словарных значений берется NULL, и резултат применнения
            // оператора IsNull к значению  NULL и "RUB" берется "RUB"
            new()
            {
                RuleId = 2301,
                RuleKind = RuleKind.SourceColumnCopyDictionaryOnly,
                RuleOperator = RuleOperator.IsNull,
                SourceEntity =new RuleEntityDto( new List<string>
                {
                    "ПНП назнач.",
                    "ПНП назначен.",
                    "ПНП назначения"
                }),
                DestinationColumn = "PNPToCurrency",
                Dictionary = new RuleDictionaryDto(ZeroToEmptyDictionary()),
                SourceWorksheets = allWorksheets
            },
 
            // 44 - all
            new()
            {
                RuleId = 4400,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "RateCalcType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("Т") }), // За Тонну
                SourceWorksheets = allWorksheets
            },
            //  45 - all
            new()
            {
                RuleId = 4500,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "RateType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("4") }), // Индикативная

                SourceWorksheets = allWorksheets
            },
            // 47 - all
            new()
            {
                RuleId = 4700,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                DestinationColumn = "NodeFrom",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Станция отправления",
                    "Ст. отправления"
                }),
                SourceWorksheets = allWorksheets,
                Dictionary = new RuleDictionaryDto(NodesDictionary)
            },
            // 48 - all
            new()
            {
                RuleId = 4800,
                RuleKind = RuleKind.SourceColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                DestinationColumn = "NodeTo",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Станция назначения",
                    "Cтанция назначения",
                    "Ст. назначения"

                }),
                SourceWorksheets = allWorksheets,
                Dictionary = new RuleDictionaryDto(NodesDictionary)
            },
            // 49  - all
            new()
            {
                RuleId = 4900,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TransportKind",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("Rail") }), //Железнорожный транспорт
                SourceWorksheets = allWorksheets
            },
            // 50 - all кроме ТК РФ
            new()
            {
                RuleId = 5000,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("Rail_VC_other") }), //ВЦ прочие грузы
                SourceWorksheets = allWorksheets
                    .Except(TKRFWorksheets)
                    .Except(SPBTWorksheets)
                    .Except(SPTTKBGSWorksheets)
                    .Except(KauchukWorksheets)
                    .Except(PEPPWorksheets)
                    .ToList()
            },
            // 50 - ТК РФ + СПБТ-Нягань-ТК +  СПТ Тобольск ТК БГС
            new()
            {
                RuleId = 5010,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("Rail_TK_20") }), //
                SourceWorksheets = TKRFWorksheets
                    .Union(SPBTWorksheets)
                    .Union(SPTTKBGSWorksheets)
                    .ToList()
            },
            // 50 – КАУЧУКи  +  ПЭ-ПП  с ВС ИНДИКАТИВ
            new()
            {
                RuleId = 5020,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "TransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("Rail_KV") }), //
                SourceWorksheets = KauchukWorksheets
                    .Union(PEPPWorksheets)
                    .ToList()
            },
            // 51 - СУГ-1 
            new()
            {
                RuleId = 5101,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("36.82") }),
                SourceWorksheets = Sug10Worksheets
            },
            // 51 - 06 – СУГ-2 - фракция пент изопент
            new()
            {
                RuleId = 5102,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("39.09") }),
                SourceWorksheets = Sug20Worksheets
            },
            // 51 - 06 – СУГ-3 - бутадиен
            new()
            {
                RuleId = 5103,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("43.28") }),
                SourceWorksheets = Sug31Worksheets
            },
            // 51 - 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ
            new()
            {
                RuleId = 5104,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("36.18") }),
                SourceWorksheets = Sug32Worksheets
            },
            // 51  - 06 – ШФЛУ + ТК РФ +
            // СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
           //+ СПТ Тобольск ТК + БГС
           // + КАУЧУКи с ВС
           //+ ПЭ-ПП с ВС ИНДИКАТИВ
            new()
            {
                RuleId = 5105,
                RuleKind = RuleKind.SourceColumnCopy,
                DestinationColumn = "EffectiveLoadOfTransportType",
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Расчетный вес, т",
                    "Загрузка, т",
                    "Вес груза, брутто, т"
                }),
                SourceWorksheets = ShfluWorksheets
                    .Union(TKRFWorksheets)
                    .Union(SPBTWorksheets)
                    .Union(SPTTKBGSWorksheets)
                    .Union(KauchukWorksheets)
                    .Union(PEPPWorksheets)
                    .ToList()
            },

            // 51 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022
            new()
            {
                RuleId = 5120,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("58.14") }),
                SourceWorksheets = Nb10Worksheets
            },
            // 51 - 06 – НБ-2 - ЖПП СПТ и т.д
            new()
            {
                RuleId = 5130,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("57.37") }),
                SourceWorksheets = Nb21Worksheets
            },
            // 51 – НБ-2 - химия
            new()
            {
                RuleId = 5140,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("55.86") }),
                SourceWorksheets = Nb22Worksheets
            },
            // 51  06 – НБ-3 - БГС
            new()
            {
                RuleId = 5150,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("48.68") }),
                SourceWorksheets = Nb30Worksheets
            },
            // 51  – НБ-5 Натрия гидроксид, каустики
            new()
            {
                RuleId = 5151,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("53") }),
                SourceWorksheets = Nb50Worksheets
            },
            // 51  - 06 – НБ-8 
            new()
            {
                RuleId = 5152,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("57.5") }),
                SourceWorksheets = Nb80Worksheets
            },
            // 51  - 06 – НБ-7
            new()
            {
                RuleId = 5153,
                RuleKind = RuleKind.DestinationSheetConstant,
                RuleDataType = RuleType.Number,
                DestinationColumn = "EffectiveLoadOfTransportType",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("55.86") }),
                SourceWorksheets = Nb70Worksheets
            },
            // 53 - СУГ-1- "Ставки"
            new()
            {
                RuleId = 5300,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug11ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    1001 // "Ставки"
                }
            },
            // 53 - СУГ-1 - "Ставки без охраны"
            new()
            {
                RuleId = 5301,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug12ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    1002 // "Ставки без охраны"
                }
            },
            // 53 - СУГ-1 - "Спецставка"
            new()
            {
                RuleId = 5302,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug13ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    1003 // "Спецставка"
                }
            },

            // 53  - СУГ-2 - фракция пент изопент
            new()
            {
                RuleId = 5305,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug20ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Sug20Worksheets
            },

            // 51 - 06 – СУГ-3 - бутадиен
            new()
            {
                RuleId = 5306,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug31ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Sug31Worksheets
            },
            // 51 - 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Пропилен, изобутилен "
            new()
            {
                RuleId = 5307,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug321ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    3201 // "Пропилен, изобутилен "
                }
            },
            // 51 - 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ --  "изобутилен до 720 км со скидкой"
            new()
            {
                RuleId = 5308,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug322ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    3202 // "изобутилен до 720 км со скидкой"
                }
            },
            // 51 - 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Бутилен, изопрен, БДФ "
            new()
            {
                RuleId = 5309,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Sug323ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    3203 // "Бутилен, изопрен, БДФ "
                }
            },
            // 51  - 06 – ШФЛУ
            new()
            {
                RuleId = 5310,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(ShfluProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = ShfluWorksheets
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  - Ставки
            new()
            {
                RuleId = 5320,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb11ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6001 //Ставки
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  --- Ставки со скидкой на 720 км
            new()
            {
                RuleId = 5321,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb12ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6002 // Ставки со скидкой на 720 км
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- МТБЭ Сургут
            new()
            {
                RuleId = 5322,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb13ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6003 //МТБЭ Сургут
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- МТБЭ Сахалин МАЙ 2022
            new()
            {
                RuleId = 5323,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb14ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6004 //МТБЭ Сахалин МАЙ 2022
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  - Стирол
            new()
            {
                RuleId = 5324,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb15ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6005 //Стирол
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022 -- Гликоли
            new()
            {
                RuleId = 5325,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb16ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6006 //Гликоли
                }
            },
            // 53 - 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022 -- Гликоли КЛН  МАЙ
            new()
            {
                RuleId = 5326,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb17ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    6007 //Гликоли КЛН  МАЙ
                }
            },

            // 53 - 06 – НБ-2 - ЖПП СПТ и т.д  -- ставки 2022
            new()
            {
                RuleId = 5330,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb211ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    7101 //ставки 2022
                }
            },
            // 53 - 06 – НБ-2 - ЖПП СПТ и т.д Сахалин 2022 ИНДИКАТИВ МАЙ!!!
            new()
            {
                RuleId = 5331,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb212ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    7102 //Сахалин 2022 ИНДИКАТИВ МАЙ!!!
                }
            },
            // 53 - 06 – НБ-2 - химия  -- ставки 2022
            new()
            {
                RuleId = 5335,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb221ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    7201 //ставки 2022
                }
            },
            // 53 - 06 – НБ-2 - химия   -- Ставки со скидкой на расст.  ап
            new()
            {
                RuleId = 5336,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb222ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>
                {
                    7202 //Ставки со скидкой на расст.  ап
                }
            },
            // 53 - 06 – НБ-3 - БГС
            new()
            {
                RuleId = 5340,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb30ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Nb30Worksheets
            },
            // 53 - 06 – НБ-5 Натрия гидроксид, каустики
            new()
            {
                RuleId = 5345,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb50ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Nb50Worksheets
            },
            // 53 - 06 – НБ-7
            new()
            {
                RuleId = 5348,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb70ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Nb70Worksheets
            },
            // 53 - 06 – НБ-8
            new()
            {
                RuleId = 5349,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(Nb80ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = Nb80Worksheets
            },
            // 53 - 06 – ТК РФ
            new()
            {
                RuleId = 5350,
                RuleKind = RuleKind.SourceColumnCopy,
                DestinationColumn = "Product",
                SourceEntity = new RuleEntityDto(new List<string> { "Груз" }),
                TreatMissingDictionaryValueAsError = true,
                Dictionary = new RuleDictionaryDto(TKRFProductNamesDictionary),
                SourceWorksheets = TKRFWorksheets
            },

             // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  ПБТ
            new()
            {
                RuleId = 5355,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(SPBT_PBT_ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>{ 20001 } // ПБТ
            },
            // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Пропилен
            new()
            {
                RuleId = 5356,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(SPBT_Propilen_ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>{ 20002, 20003 } // Пропилен
            },
            // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутадиен
            new()
            {
                RuleId = 5357,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(SPBT_Butadien_ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>{ 20004 } // Бутадиен
            },

            // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутилен
            new()
            {
                RuleId = 5358,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(SPBT_Butilen_ProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = new List<int>{ 20005 } // Бутилен
            },

            // 53 - СПТ Тобольск ТК + БГС
            new()
            {
                RuleId = 5360,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(SPTTKBGSProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = SPTTKBGSWorksheets // СПТ Тобольск ТК + БГС
            },

            // 53 - 06 КАУЧУКи
            new()
            {
                RuleId = 5362,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(KauchukProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = KauchukWorksheets // 06 КАУЧУКи
            },
            // 53 - - ПЭ-ПП
            new()
            {
                RuleId = 5363,
                RuleKind = RuleKind.SheetMultiplier,
                DestinationColumn = "Product",
                Dictionary = new RuleDictionaryDto(PEPPProductsDictionary
                    .Where(p => p.SourceValue != null)
                    .Select(p => new RuleDictionaryItemDto(p.SourceValue!))
                    .ToList()),
                SourceWorksheets = PEPPWorksheets // - ПЭ-ПП
            },


            // 52 - all
            // Применять можно только после правила продуктов
            new()
            {
                RuleId = 5200,
                RuleKind = RuleKind.DestinationColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                DestinationColumn = "ProductGroup",
                SourceEntity = new RuleEntityDto(new List<string> { "Product" }),
                Dictionary = new RuleDictionaryDto(AllProductsDictionary),
                SourceWorksheets = allWorksheets
            },
            // 3 - all !!!!!!! Now SUG-1 + NB-7 + TK FR only
            // Применять можно только после правила продуктов
            new()
            {
                RuleId = 3000,
                RuleKind = RuleKind.DestinationColumnCopy,
                TreatMissingDictionaryValueAsError = true,
                DestinationColumn = "ETSNGCode",
                SourceEntity = new RuleEntityDto(new List<string> { "Product" }),
                Dictionary = new RuleDictionaryDto(ProductEtsngDictionary),
                SourceWorksheets = allWorksheets
            },

            // 32  - all
            // Применять можно только после правила продуктов
            new()
            {
                RuleId = 3200,
                RuleKind = RuleKind.SheetParameter,
                RuleDataType = RuleType.DateTime,
                DestinationColumn = "CurrencyRateMonth",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("CurrencyRateMonth") }),
                SourceWorksheets = allWorksheets
            },
            // 54 - all
            // Применять можно только после правила продуктов
            new()
            {
                RuleId = 5400,
                RuleKind = RuleKind.SheetParameter,
                RuleDataType = RuleType.DateTime,
                DestinationColumn = "StartDate", //Период действия с
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("StartDate") }),
                SourceWorksheets = allWorksheets
            },
            // 55 - all
            // Применять можно только после правила продуктов
            new()
            {
                RuleId = 5500,
                RuleKind = RuleKind.SheetParameter,
                RuleDataType = RuleType.DateTime,
                DestinationColumn = "EndDate", //Период действия по
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("EndDate") }),
                SourceWorksheets = allWorksheets
            },
            // 58 - all
            new()
            {
                RuleId = 5800,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "GeneralCurrency",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
                SourceWorksheets = allWorksheets
            },
            // 59 - all
            new()
            {
                RuleId = 5900,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "stg_Operation",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("1") }), // Insert
                SourceWorksheets = allWorksheets
            },
            // - all
            new()
            {
                RuleId = 10000,
                RuleKind = RuleKind.DestinationSheetConstant,
                DestinationColumn = "ActualRate",
                Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("0") }), // False
                SourceWorksheets = allWorksheets
            }
        };
        var ruleIds = new HashSet<int>(rules.Count);
        foreach (var rule in rules)
        {
            if (ruleIds.Contains(rule.RuleId))
            {
                throw new InvalidOperationException($"Duplicate rule with ID {rule.RuleId}");
            }

            ruleIds.Add(rule.RuleId);
        }

        for (var index = 0; index < rules.Count; index++)
        {
            var rule = rules[index];
            rule.Order = index;
            // все кроме "Охрана груза."
            rule.Mandatory = rule.RuleId != 401;
        }

        return rules;
    }

    public async Task<List<RuleDto>> GetRulesAsync(int worksheetId) =>
        (await GetRulesAsync())
        .Where(r => r.SourceWorksheets.Contains(worksheetId))
        .ToList();

    private static List<RuleDictionaryItemDto> ZeroToEmptyDictionary() =>
        new()
        {
            new RuleDictionaryItemDto("0.00", ""),
            new RuleDictionaryItemDto("0.0", ""),
            new RuleDictionaryItemDto("0", "")
        };

    private static List<RuleDictionaryItemDto> ReadNodeDictionaryFromExcel()
    {
        var fileProvider = new FileProvider();
        var stream = fileProvider.GetFileStream("NodesDictionary.xlsx");
        var workbook = new XLWorkbook(stream);
        var worksheet = workbook.Worksheet(1);
        var dictionaryFromExcel = new List<RuleDictionaryItemDto>();
        foreach (var row in worksheet.RowsUsed())
        {
            var nkhtkValue = row.Cell(1).CachedValue;
            var svtValue = row.Cell(3).CachedValue;
            var key = nkhtkValue.ConvertToString();
            if (!string.IsNullOrEmpty(key))
            {
                var value = svtValue.ConvertToString() ?? string.Empty;
                dictionaryFromExcel.Add(new RuleDictionaryItemDto(key, value));
            }
        }

        return dictionaryFromExcel;
    }

    private static List<RuleDictionaryItemDto> ReadDistanceDictionaryFromExcel(int columnIndex)
    {
        var fileProvider = new FileProvider();
        var stream = fileProvider.GetFileStream("TSDistanceDictionary.xlsx");
        var workbook = new XLWorkbook(stream);
        var worksheet = workbook.Worksheet(3);
        var dictionaryFromExcel = new List<RuleDictionaryItemDto>();
        foreach (var row in worksheet.RowsUsed())
        {
            var nkhtkValue = row.Cell(1).CachedValue;
            var svtValue = row.Cell(columnIndex).CachedValue;
            var key = nkhtkValue.ToString();
            if (!string.IsNullOrEmpty(key))
            {
                var value = svtValue.ConvertToString() ?? string.Empty;
                dictionaryFromExcel.Add(new RuleDictionaryItemDto(key, value));
            }
        }

        return dictionaryFromExcel;
    }
}