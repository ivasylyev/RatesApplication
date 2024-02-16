namespace RatesModels
{
    public class RateListItemDto
    {
        public long RateId { get; set; }
        public DateOnly StartDate { get; set; }
        public DateOnly EndDate { get; set; }
        public LocationNodeDto NodeFrom { get; set; }

        public LocationNodeDto NodeTo { get; set; }
        public decimal Value { get; set; }


    }
}
